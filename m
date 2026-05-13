Return-Path: <io-uring+bounces-13307-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4F8oM8ZFBGowGgIAu9opvQ
	(envelope-from <io-uring+bounces-13307-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 11:35:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5BD530B70
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 11:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B1E23254BA1
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 09:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3DD3E5597;
	Wed, 13 May 2026 09:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="A/0H/wRV"
X-Original-To: io-uring@vger.kernel.org
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6C3C4546
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 09:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778663661; cv=none; b=PMG2uV7k/CZh7KTt+S/VJLclmcKKtN/pN7H2baghxrYAz1qT8hfTxMpMh1KQPaV3M1hdQHpQ2JC7KeB4M6hKHzu27OatOdbGWOo2JmeitSD/PVYIXX2fMrsDTAgZqJefVhfd4nGJ8QdYnpSCJK3AA7q4Vc2LRiUVy7bazfl4xDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778663661; c=relaxed/simple;
	bh=Uw0uScx8E1a3wIEO5ri99NR4rDuQtAaM+XVL+5J8xD0=;
	h=Subject:Cc:Date:Message-Id:Mime-Version:Content-Type:To:From; b=qPbEPIuvT3IZ9QfAFaKVEqUkubTV1vndHNaagIuOde21KqvXaNQAg+beM50yrZWMdOvspD03r6i+groNhauzgshj8ZwhkMqo2o9GRykCLsvqOHSnxR8eEbWUbRQplS+TjYlWLHx/taWyK813gCRGYvYWIDlLL5ly64uFP9SRc3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=A/0H/wRV; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778663649; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=y9nLA5PRTc6yF2cdJng5j4g+eBMacB7v/4HE+A0Ob9E=;
 b=A/0H/wRVvAkRm3f4WLVAek8EuCBsKjdE83i8f2B9BaxsKhQaCyCuQo4RjKc0IBqOdz4Rsx
 f9Ai4yirwD8zNcVPGbzWttMP5qi9v++EbwGYFCinmlG8U+O5uBHaCavcJrC3Ogx1PHQvax
 SxoX9/mznmjt2teMCRbCBkBGWcafWD6OMLi2UI2RMMNmVDWBrQOijJi/9uudQUWgxQia+4
 tzrOCiaZjlqPUFGr+WCq4b8YaA/eC3rK50twtuWp6FeypujndzwX7r6FIiTD4au0abSvN8
 sbeKegkpFUDgtp0fxZ9BR0OSP4GIbwcobBMnWUF+o2P7djQBnBb/eEnhTXvEKA==
Subject: [PATCH RESEND] dm: limit target bio polling to one shot
X-Lms-Return-Path: <lba+26a0440e0+e2ce27+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Wed, 13 May 2026 17:13:49 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Message-Id: <20260513091349.2194-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <bmarzins@redhat.com>, 
	<dm-devel@lists.linux.dev>
From: "Fengnan Chang" <changfengnan@bytedance.com>
X-Rspamd-Queue-Id: EC5BD530B70
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13307-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org,redhat.com,kernel.org,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bytedance.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
The caller only knows about the dm queue, so it may decide to do a
spinning poll if it thinks a single queue is being polled. Passing those
flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
queue from inside dm_poll_bio().

With io_uring IOPOLL on a dm-stripe target this can keep a task in

  dm_poll_bio() -> bio_poll() -> blk_mq_poll()

long enough to trigger an RCU CPU stall, before io_uring gets back to
io_iopoll_check() and its need_resched() check.

Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
bios. The caller can invoke dm_poll_bio() again if it wants to keep
polling, and it also gets a chance to reap completions or reschedule
between passes.

Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll()")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 drivers/md/dm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e178fe19973ea..8f44fbbcf3da2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
 	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
 
 	/* don't poll if the mapped io is done */
-	if (atomic_read(&io->io_count) > 1)
-		bio_poll(&io->tio.clone, iob, flags);
+	if (atomic_read(&io->io_count) > 1) {
+		/*
+		 * DM hides the target queues from the upper poller, which may
+		 * decide it is safe to spin on a single stacked queue.  Do not
+		 * pass that spinning policy down to a target queue: one slow
+		 * clone could keep the task inside dm_poll_bio() for a long
+		 * time.  Poll target bios once and let the caller decide
+		 * whether to keep polling, reap completions or reschedule.
+		 */
+		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
+	}
 
 	/* bio_poll holds the last reference */
 	return atomic_read(&io->io_count) == 1;
-- 
2.39.5 (Apple Git-154)

