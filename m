Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8233528B00
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbiEPQtR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbiEPQs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886693CA53
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:50 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEaOPo028193
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=95IBhF0kImkAgtFy9pvGGkvKxSMcZPFHzVuwJjta218=;
 b=J5H3334U8nQE+nIIeJJxiHMA2URK5rNv+mlmJPgIi2GmrINuOTwiwjIpwLolBXRi1oa0
 1jINdLLVwinoxb+4yr9rwZwKTWTwArdsh4XZr59fUN6B4e/y2xPEOgtcfOpr8DjCsu9A
 F148IXT2LKBDOrePWybclVL48ym7cpkrQk0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g29hu2rvr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:50 -0700
Received: from twshared35748.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:48 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 83FB7F146DE7; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 12/16] mm: factor out _balance_dirty_pages() from balance_dirty_pages()
Date:   Mon, 16 May 2022 09:47:14 -0700
Message-ID: <20220516164718.2419891-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5ucKi0vEVOQqzXCgWlUpz-y8tHWzeXRV
X-Proofpoint-GUID: 5ucKi0vEVOQqzXCgWlUpz-y8tHWzeXRV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This factors out the for loop in balance_dirty_pages() into a new
function called _balance_dirty_pages(). By factoring out this function
the async write code can determine if it has to wait to throttle writes
or not. The function _balance_dirty_pages() returns the sleep time.
If the sleep time is greater 0, then the async write code needs to thrott=
le.

To maintain the context for consecutive calls of _balance_dirty_pages()
and maintain the current behavior a new data structure called bdp_ctx
has been introduced.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/page-writeback.c | 452 +++++++++++++++++++++++---------------------
 1 file changed, 239 insertions(+), 213 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7e2da284e427..cbb74c0666c6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -140,6 +140,29 @@ struct dirty_throttle_control {
 	unsigned long		pos_ratio;
 };
=20
+/* context for consecutive calls to _balance_dirty_pages() */
+struct bdp_ctx {
+	long			pause;
+	unsigned long		now;
+	unsigned long		start_time;
+	unsigned long		task_ratelimit;
+	unsigned long		dirty_ratelimit;
+	unsigned long		nr_reclaimable;
+	int			nr_dirtied_pause;
+	bool			dirty_exceeded;
+
+	struct dirty_throttle_control gdtc_stor;
+	struct dirty_throttle_control mdtc_stor;
+	struct dirty_throttle_control *sdtc;
+} bdp_ctx;
+
+/* initialize _balance_dirty_pages() context */
+#define BDP_CTX_INIT(ctx, wb)				\
+	.gdtc_stor =3D { GDTC_INIT(wb) },			\
+	.mdtc_stor =3D { MDTC_INIT(wb, &ctx.gdtc_stor) },	\
+	.start_time =3D jiffies,				\
+	.dirty_exceeded =3D false
+
 /*
  * Length of period for aging writeout fractions of bdis. This is an
  * arbitrarily chosen number. The longer the period, the slower fraction=
s will
@@ -1538,261 +1561,264 @@ static inline void wb_dirty_limits(struct dirty=
_throttle_control *dtc)
 	}
 }
=20
-/*
- * balance_dirty_pages() must be called by processes which are generatin=
g dirty
- * data.  It looks at the number of dirty pages in the machine and will =
force
- * the caller to wait once crossing the (background_thresh + dirty_thres=
h) / 2.
- * If we're over `background_thresh' then the writeback threads are woke=
n to
- * perform some writeout.
- */
-static void balance_dirty_pages(struct bdi_writeback *wb,
-				unsigned long pages_dirtied)
+static inline int _balance_dirty_pages(struct bdi_writeback *wb,
+					unsigned long pages_dirtied, struct bdp_ctx *ctx)
 {
-	struct dirty_throttle_control gdtc_stor =3D { GDTC_INIT(wb) };
-	struct dirty_throttle_control mdtc_stor =3D { MDTC_INIT(wb, &gdtc_stor)=
 };
-	struct dirty_throttle_control * const gdtc =3D &gdtc_stor;
-	struct dirty_throttle_control * const mdtc =3D mdtc_valid(&mdtc_stor) ?
-						     &mdtc_stor : NULL;
-	struct dirty_throttle_control *sdtc;
-	unsigned long nr_reclaimable;	/* =3D file_dirty */
+	struct dirty_throttle_control * const gdtc =3D &ctx->gdtc_stor;
+	struct dirty_throttle_control * const mdtc =3D mdtc_valid(&ctx->mdtc_st=
or) ?
+						     &ctx->mdtc_stor : NULL;
 	long period;
-	long pause;
 	long max_pause;
 	long min_pause;
-	int nr_dirtied_pause;
-	bool dirty_exceeded =3D false;
-	unsigned long task_ratelimit;
-	unsigned long dirty_ratelimit;
 	struct backing_dev_info *bdi =3D wb->bdi;
 	bool strictlimit =3D bdi->capabilities & BDI_CAP_STRICTLIMIT;
-	unsigned long start_time =3D jiffies;
=20
-	for (;;) {
-		unsigned long now =3D jiffies;
-		unsigned long dirty, thresh, bg_thresh;
-		unsigned long m_dirty =3D 0;	/* stop bogus uninit warnings */
-		unsigned long m_thresh =3D 0;
-		unsigned long m_bg_thresh =3D 0;
-
-		nr_reclaimable =3D global_node_page_state(NR_FILE_DIRTY);
-		gdtc->avail =3D global_dirtyable_memory();
-		gdtc->dirty =3D nr_reclaimable + global_node_page_state(NR_WRITEBACK);
+	unsigned long dirty, thresh, bg_thresh;
+	unsigned long m_dirty =3D 0;	/* stop bogus uninit warnings */
+	unsigned long m_thresh =3D 0;
+	unsigned long m_bg_thresh =3D 0;
=20
-		domain_dirty_limits(gdtc);
+	ctx->now =3D jiffies;
+	ctx->nr_reclaimable =3D global_node_page_state(NR_FILE_DIRTY);
+	gdtc->avail =3D global_dirtyable_memory();
+	gdtc->dirty =3D ctx->nr_reclaimable + global_node_page_state(NR_WRITEBA=
CK);
=20
-		if (unlikely(strictlimit)) {
-			wb_dirty_limits(gdtc);
+	domain_dirty_limits(gdtc);
=20
-			dirty =3D gdtc->wb_dirty;
-			thresh =3D gdtc->wb_thresh;
-			bg_thresh =3D gdtc->wb_bg_thresh;
-		} else {
-			dirty =3D gdtc->dirty;
-			thresh =3D gdtc->thresh;
-			bg_thresh =3D gdtc->bg_thresh;
-		}
+	if (unlikely(strictlimit)) {
+		wb_dirty_limits(gdtc);
=20
-		if (mdtc) {
-			unsigned long filepages, headroom, writeback;
+		dirty =3D gdtc->wb_dirty;
+		thresh =3D gdtc->wb_thresh;
+		bg_thresh =3D gdtc->wb_bg_thresh;
+	} else {
+		dirty =3D gdtc->dirty;
+		thresh =3D gdtc->thresh;
+		bg_thresh =3D gdtc->bg_thresh;
+	}
=20
-			/*
-			 * If @wb belongs to !root memcg, repeat the same
-			 * basic calculations for the memcg domain.
-			 */
-			mem_cgroup_wb_stats(wb, &filepages, &headroom,
-					    &mdtc->dirty, &writeback);
-			mdtc->dirty +=3D writeback;
-			mdtc_calc_avail(mdtc, filepages, headroom);
-
-			domain_dirty_limits(mdtc);
-
-			if (unlikely(strictlimit)) {
-				wb_dirty_limits(mdtc);
-				m_dirty =3D mdtc->wb_dirty;
-				m_thresh =3D mdtc->wb_thresh;
-				m_bg_thresh =3D mdtc->wb_bg_thresh;
-			} else {
-				m_dirty =3D mdtc->dirty;
-				m_thresh =3D mdtc->thresh;
-				m_bg_thresh =3D mdtc->bg_thresh;
-			}
-		}
+	if (mdtc) {
+		unsigned long filepages, headroom, writeback;
=20
 		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the wb limits are ramping up in case of !strictlimit.
-		 *
-		 * In strictlimit case make decision based on the wb counters
-		 * and limits. Small writeouts when the wb limits are ramping
-		 * up are the price we consciously pay for strictlimit-ing.
-		 *
-		 * If memcg domain is in effect, @dirty should be under
-		 * both global and memcg freerun ceilings.
+		 * If @wb belongs to !root memcg, repeat the same
+		 * basic calculations for the memcg domain.
 		 */
-		if (dirty <=3D dirty_freerun_ceiling(thresh, bg_thresh) &&
-		    (!mdtc ||
-		     m_dirty <=3D dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
-			unsigned long intv;
-			unsigned long m_intv;
+		mem_cgroup_wb_stats(wb, &filepages, &headroom,
+				    &mdtc->dirty, &writeback);
+		mdtc->dirty +=3D writeback;
+		mdtc_calc_avail(mdtc, filepages, headroom);
=20
-free_running:
-			intv =3D dirty_poll_interval(dirty, thresh);
-			m_intv =3D ULONG_MAX;
+		domain_dirty_limits(mdtc);
=20
-			current->dirty_paused_when =3D now;
-			current->nr_dirtied =3D 0;
-			if (mdtc)
-				m_intv =3D dirty_poll_interval(m_dirty, m_thresh);
-			current->nr_dirtied_pause =3D min(intv, m_intv);
-			break;
+		if (unlikely(strictlimit)) {
+			wb_dirty_limits(mdtc);
+			m_dirty =3D mdtc->wb_dirty;
+			m_thresh =3D mdtc->wb_thresh;
+			m_bg_thresh =3D mdtc->wb_bg_thresh;
+		} else {
+			m_dirty =3D mdtc->dirty;
+			m_thresh =3D mdtc->thresh;
+			m_bg_thresh =3D mdtc->bg_thresh;
 		}
+	}
=20
-		if (unlikely(!writeback_in_progress(wb)))
-			wb_start_background_writeback(wb);
+	/*
+	 * Throttle it only when the background writeback cannot
+	 * catch-up. This avoids (excessively) small writeouts
+	 * when the wb limits are ramping up in case of !strictlimit.
+	 *
+	 * In strictlimit case make decision based on the wb counters
+	 * and limits. Small writeouts when the wb limits are ramping
+	 * up are the price we consciously pay for strictlimit-ing.
+	 *
+	 * If memcg domain is in effect, @dirty should be under
+	 * both global and memcg freerun ceilings.
+	 */
+	if (dirty <=3D dirty_freerun_ceiling(thresh, bg_thresh) &&
+	    (!mdtc ||
+	     m_dirty <=3D dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
+		unsigned long intv;
+		unsigned long m_intv;
=20
-		mem_cgroup_flush_foreign(wb);
+free_running:
+		intv =3D dirty_poll_interval(dirty, thresh);
+		m_intv =3D ULONG_MAX;
+
+		current->dirty_paused_when =3D ctx->now;
+		current->nr_dirtied =3D 0;
+		if (mdtc)
+			m_intv =3D dirty_poll_interval(m_dirty, m_thresh);
+		current->nr_dirtied_pause =3D min(intv, m_intv);
+		return 0;
+	}
+
+	if (unlikely(!writeback_in_progress(wb)))
+		wb_start_background_writeback(wb);
=20
+	mem_cgroup_flush_foreign(wb);
+
+	/*
+	 * Calculate global domain's pos_ratio and select the
+	 * global dtc by default.
+	 */
+	if (!strictlimit) {
+		wb_dirty_limits(gdtc);
+
+		if ((current->flags & PF_LOCAL_THROTTLE) &&
+		    gdtc->wb_dirty <
+		    dirty_freerun_ceiling(gdtc->wb_thresh,
+					  gdtc->wb_bg_thresh))
+			/*
+			 * LOCAL_THROTTLE tasks must not be throttled
+			 * when below the per-wb freerun ceiling.
+			 */
+			goto free_running;
+	}
+
+	ctx->dirty_exceeded =3D (gdtc->wb_dirty > gdtc->wb_thresh) &&
+		((gdtc->dirty > gdtc->thresh) || strictlimit);
+
+	wb_position_ratio(gdtc);
+	ctx->sdtc =3D gdtc;
+
+	if (mdtc) {
 		/*
-		 * Calculate global domain's pos_ratio and select the
-		 * global dtc by default.
+		 * If memcg domain is in effect, calculate its
+		 * pos_ratio.  @wb should satisfy constraints from
+		 * both global and memcg domains.  Choose the one
+		 * w/ lower pos_ratio.
 		 */
 		if (!strictlimit) {
-			wb_dirty_limits(gdtc);
+			wb_dirty_limits(mdtc);
=20
 			if ((current->flags & PF_LOCAL_THROTTLE) &&
-			    gdtc->wb_dirty <
-			    dirty_freerun_ceiling(gdtc->wb_thresh,
-						  gdtc->wb_bg_thresh))
+			    mdtc->wb_dirty <
+			    dirty_freerun_ceiling(mdtc->wb_thresh,
+						  mdtc->wb_bg_thresh))
 				/*
-				 * LOCAL_THROTTLE tasks must not be throttled
-				 * when below the per-wb freerun ceiling.
+				 * LOCAL_THROTTLE tasks must not be
+				 * throttled when below the per-wb
+				 * freerun ceiling.
 				 */
 				goto free_running;
 		}
+		ctx->dirty_exceeded |=3D (mdtc->wb_dirty > mdtc->wb_thresh) &&
+			((mdtc->dirty > mdtc->thresh) || strictlimit);
=20
-		dirty_exceeded =3D (gdtc->wb_dirty > gdtc->wb_thresh) &&
-			((gdtc->dirty > gdtc->thresh) || strictlimit);
+		wb_position_ratio(mdtc);
+		if (mdtc->pos_ratio < gdtc->pos_ratio)
+			ctx->sdtc =3D mdtc;
+	}
=20
-		wb_position_ratio(gdtc);
-		sdtc =3D gdtc;
+	if (ctx->dirty_exceeded && !wb->dirty_exceeded)
+		wb->dirty_exceeded =3D 1;
=20
-		if (mdtc) {
-			/*
-			 * If memcg domain is in effect, calculate its
-			 * pos_ratio.  @wb should satisfy constraints from
-			 * both global and memcg domains.  Choose the one
-			 * w/ lower pos_ratio.
-			 */
-			if (!strictlimit) {
-				wb_dirty_limits(mdtc);
-
-				if ((current->flags & PF_LOCAL_THROTTLE) &&
-				    mdtc->wb_dirty <
-				    dirty_freerun_ceiling(mdtc->wb_thresh,
-							  mdtc->wb_bg_thresh))
-					/*
-					 * LOCAL_THROTTLE tasks must not be
-					 * throttled when below the per-wb
-					 * freerun ceiling.
-					 */
-					goto free_running;
-			}
-			dirty_exceeded |=3D (mdtc->wb_dirty > mdtc->wb_thresh) &&
-				((mdtc->dirty > mdtc->thresh) || strictlimit);
+	if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
+				   BANDWIDTH_INTERVAL))
+		__wb_update_bandwidth(gdtc, mdtc, true);
+
+	/* throttle according to the chosen dtc */
+	ctx->dirty_ratelimit =3D READ_ONCE(wb->dirty_ratelimit);
+	ctx->task_ratelimit =3D ((u64)ctx->dirty_ratelimit * ctx->sdtc->pos_rat=
io) >>
+						RATELIMIT_CALC_SHIFT;
+	max_pause =3D wb_max_pause(wb, ctx->sdtc->wb_dirty);
+	min_pause =3D wb_min_pause(wb, max_pause,
+				 ctx->task_ratelimit, ctx->dirty_ratelimit,
+				 &ctx->nr_dirtied_pause);
+
+	if (unlikely(ctx->task_ratelimit =3D=3D 0)) {
+		period =3D max_pause;
+		ctx->pause =3D max_pause;
+		goto pause;
+	}
+	period =3D HZ * pages_dirtied / ctx->task_ratelimit;
+	ctx->pause =3D period;
+	if (current->dirty_paused_when)
+		ctx->pause -=3D ctx->now - current->dirty_paused_when;
+	/*
+	 * For less than 1s think time (ext3/4 may block the dirtier
+	 * for up to 800ms from time to time on 1-HDD; so does xfs,
+	 * however at much less frequency), try to compensate it in
+	 * future periods by updating the virtual time; otherwise just
+	 * do a reset, as it may be a light dirtier.
+	 */
+	if (ctx->pause < min_pause) {
+		trace_balance_dirty_pages(wb,
+					  ctx->sdtc->thresh,
+					  ctx->sdtc->bg_thresh,
+					  ctx->sdtc->dirty,
+					  ctx->sdtc->wb_thresh,
+					  ctx->sdtc->wb_dirty,
+					  ctx->dirty_ratelimit,
+					  ctx->task_ratelimit,
+					  pages_dirtied,
+					  period,
+					  min(ctx->pause, 0L),
+					  ctx->start_time);
+		if (ctx->pause < -HZ) {
+			current->dirty_paused_when =3D ctx->now;
+			current->nr_dirtied =3D 0;
+		} else if (period) {
+			current->dirty_paused_when +=3D period;
+			current->nr_dirtied =3D 0;
+		} else if (current->nr_dirtied_pause <=3D pages_dirtied)
+			current->nr_dirtied_pause +=3D pages_dirtied;
+		return 0;
+	}
+	if (unlikely(ctx->pause > max_pause)) {
+		/* for occasional dropped task_ratelimit */
+		ctx->now +=3D min(ctx->pause - max_pause, max_pause);
+		ctx->pause =3D max_pause;
+	}
=20
-			wb_position_ratio(mdtc);
-			if (mdtc->pos_ratio < gdtc->pos_ratio)
-				sdtc =3D mdtc;
-		}
+pause:
+	trace_balance_dirty_pages(wb,
+				  ctx->sdtc->thresh,
+				  ctx->sdtc->bg_thresh,
+				  ctx->sdtc->dirty,
+				  ctx->sdtc->wb_thresh,
+				  ctx->sdtc->wb_dirty,
+				  ctx->dirty_ratelimit,
+				  ctx->task_ratelimit,
+				  pages_dirtied,
+				  period,
+				  ctx->pause,
+				  ctx->start_time);
+
+	return ctx->pause;
+}
=20
-		if (dirty_exceeded && !wb->dirty_exceeded)
-			wb->dirty_exceeded =3D 1;
-
-		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
-					   BANDWIDTH_INTERVAL))
-			__wb_update_bandwidth(gdtc, mdtc, true);
-
-		/* throttle according to the chosen dtc */
-		dirty_ratelimit =3D READ_ONCE(wb->dirty_ratelimit);
-		task_ratelimit =3D ((u64)dirty_ratelimit * sdtc->pos_ratio) >>
-							RATELIMIT_CALC_SHIFT;
-		max_pause =3D wb_max_pause(wb, sdtc->wb_dirty);
-		min_pause =3D wb_min_pause(wb, max_pause,
-					 task_ratelimit, dirty_ratelimit,
-					 &nr_dirtied_pause);
-
-		if (unlikely(task_ratelimit =3D=3D 0)) {
-			period =3D max_pause;
-			pause =3D max_pause;
-			goto pause;
-		}
-		period =3D HZ * pages_dirtied / task_ratelimit;
-		pause =3D period;
-		if (current->dirty_paused_when)
-			pause -=3D now - current->dirty_paused_when;
-		/*
-		 * For less than 1s think time (ext3/4 may block the dirtier
-		 * for up to 800ms from time to time on 1-HDD; so does xfs,
-		 * however at much less frequency), try to compensate it in
-		 * future periods by updating the virtual time; otherwise just
-		 * do a reset, as it may be a light dirtier.
-		 */
-		if (pause < min_pause) {
-			trace_balance_dirty_pages(wb,
-						  sdtc->thresh,
-						  sdtc->bg_thresh,
-						  sdtc->dirty,
-						  sdtc->wb_thresh,
-						  sdtc->wb_dirty,
-						  dirty_ratelimit,
-						  task_ratelimit,
-						  pages_dirtied,
-						  period,
-						  min(pause, 0L),
-						  start_time);
-			if (pause < -HZ) {
-				current->dirty_paused_when =3D now;
-				current->nr_dirtied =3D 0;
-			} else if (period) {
-				current->dirty_paused_when +=3D period;
-				current->nr_dirtied =3D 0;
-			} else if (current->nr_dirtied_pause <=3D pages_dirtied)
-				current->nr_dirtied_pause +=3D pages_dirtied;
+/*
+ * balance_dirty_pages() must be called by processes which are generatin=
g dirty
+ * data.  It looks at the number of dirty pages in the machine and will =
force
+ * the caller to wait once crossing the (background_thresh + dirty_thres=
h) / 2.
+ * If we're over `background_thresh' then the writeback threads are woke=
n to
+ * perform some writeout.
+ */
+static void balance_dirty_pages(struct bdi_writeback *wb, unsigned long =
pages_dirtied)
+{
+	int ret;
+	struct bdp_ctx ctx =3D { BDP_CTX_INIT(ctx, wb) };
+
+	for (;;) {
+		ret =3D _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
+		if (!ret)
 			break;
-		}
-		if (unlikely(pause > max_pause)) {
-			/* for occasional dropped task_ratelimit */
-			now +=3D min(pause - max_pause, max_pause);
-			pause =3D max_pause;
-		}
=20
-pause:
-		trace_balance_dirty_pages(wb,
-					  sdtc->thresh,
-					  sdtc->bg_thresh,
-					  sdtc->dirty,
-					  sdtc->wb_thresh,
-					  sdtc->wb_dirty,
-					  dirty_ratelimit,
-					  task_ratelimit,
-					  pages_dirtied,
-					  period,
-					  pause,
-					  start_time);
 		__set_current_state(TASK_KILLABLE);
-		wb->dirty_sleep =3D now;
-		io_schedule_timeout(pause);
+		wb->dirty_sleep =3D ctx.now;
+		io_schedule_timeout(ctx.pause);
=20
-		current->dirty_paused_when =3D now + pause;
+		current->dirty_paused_when =3D ctx.now + ctx.pause;
 		current->nr_dirtied =3D 0;
-		current->nr_dirtied_pause =3D nr_dirtied_pause;
+		current->nr_dirtied_pause =3D ctx.nr_dirtied_pause;
=20
 		/*
 		 * This is typically equal to (dirty < thresh) and can also
 		 * keep "1000+ dd on a slow USB stick" under control.
 		 */
-		if (task_ratelimit)
+		if (ctx.task_ratelimit)
 			break;
=20
 		/*
@@ -1805,14 +1831,14 @@ static void balance_dirty_pages(struct bdi_writeb=
ack *wb,
 		 * more page. However wb_dirty has accounting errors.  So use
 		 * the larger and more IO friendly wb_stat_error.
 		 */
-		if (sdtc->wb_dirty <=3D wb_stat_error())
+		if (ctx.sdtc->wb_dirty <=3D wb_stat_error())
 			break;
=20
 		if (fatal_signal_pending(current))
 			break;
 	}
=20
-	if (!dirty_exceeded && wb->dirty_exceeded)
+	if (!ctx.dirty_exceeded && wb->dirty_exceeded)
 		wb->dirty_exceeded =3D 0;
=20
 	if (writeback_in_progress(wb))
@@ -1829,7 +1855,7 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 	if (laptop_mode)
 		return;
=20
-	if (nr_reclaimable > gdtc->bg_thresh)
+	if (ctx.nr_reclaimable > ctx.gdtc_stor.bg_thresh)
 		wb_start_background_writeback(wb);
 }
=20
--=20
2.30.2

