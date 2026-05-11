Return-Path: <io-uring+bounces-13269-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gO/jM3IfAmrAoAEAu9opvQ
	(envelope-from <io-uring+bounces-13269-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:26:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 466C9514649
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 41138305EA36
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 18:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B55147885C;
	Mon, 11 May 2026 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="HRgpH0/1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28C8307494
	for <io-uring@vger.kernel.org>; Mon, 11 May 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523746; cv=none; b=aNfBNADnA8knKgykpUTrMFzS0u4oIIOTgUiTGl07HSPyHVlUkWsGyACabWTzjrJTgGoCeeU167nyT1KyPYe/nIN5WcOo0z/svnc/N5KykCgXT06GfV6oZKjulJ3CBjEE1imBWImvsRovuxVMAIo0rC8qRSvN05OO7wYjNB3NVFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523746; c=relaxed/simple;
	bh=PoEXGjiWI0h+AaeqSyPIRSchRFPaUOgyQE+pXMnchEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9+oqCOZJad4slDEmqasfsgz8quVTt63N3G16G16iyVNkZ0tc0OmuSdtMKew7rgWbf+f/WGzLilEUP22wCkza0HGvB5SqWCaDPr1V4D+8eMjoS1vAh5FRMPxib33BFlYsp3fMc39ZX5ZsurUGfJUFAgO45nGdzfc6BRjS5/Wxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=HRgpH0/1; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47c6f914617so2379300b6e.1
        for <io-uring@vger.kernel.org>; Mon, 11 May 2026 11:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778523744; x=1779128544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjuM2soSeaudA/GxoHlDmrB0lkjGv8cbGASUjwKuCeg=;
        b=HRgpH0/1I/DfSkKMZdm6O9ECiDgcB00Hnl8VkLAeHh3c1uE3It1I4/nY+kq9Z2Xwil
         UbBwGysZVu62yMRIgQoawpV0qHHEC9QehMDuWMA3CPl2rpGte7iavwCrZdH5PY50KYb2
         hsksuPSuHHbKcBUfIYjq4wIQsZPMB0nvK/cLHEY6NPACHRaGReEsBIDf57paUSLOenfh
         BOKg8eWYpmdQ60jHdSjl/VLSxaL7XEKDdyH3IFjJaU+A/b2WXnRiHEtbhZWQdRByXSrP
         pfoIAFGREjXtUgdbvd+iKpj0JuQ2YMtEEU/gbVvx6uNCeZ2O54YrvZk8/+IgbrTNXW1o
         aZmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778523744; x=1779128544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IjuM2soSeaudA/GxoHlDmrB0lkjGv8cbGASUjwKuCeg=;
        b=SAfVFYspMlP2t1ctry8d003gr0oVisLIZ1ANgRQhZM+tCDdYrPYkrZMi9YliRAGRjs
         bUa56yaegbl6bchruYT7Qj9/qek4W3VvXQUMgDo5D5Q14CE1M1WgwQvEg/ZSO61UIdav
         2etfBM9GPY7+8+iRqxQxcvmPuLWie9edfRycm+YWeIIcynAq5+MjxzofwU65QpGFbyuJ
         LJngd8Taa8qBwo31uZT8I7JImHMJvgui3YYPEca/4V8fW91UHq66f7yw/M3TOfPzPH3A
         k0mg+bOA31WHTQOOEnDUFk/ru/XyD7W7DqHx2UvRzJtlCQ80Nseoudoeq1vew5RGEPJl
         X9WA==
X-Gm-Message-State: AOJu0Yy8PKEpQnCZ+jMR3oEatRbYpZ9R3pkRaKHMQHSS2j6jQh05/W+2
	oQf6zheWCP4xHRgQtTVURrr67+FEyabwIqSzRc8nPp/C0zejndN/rc8qKcXdCHPPC43FJSfLpFP
	O2PBz
X-Gm-Gg: Acq92OG1VHo0UVbCb72XH4qz3sLbJKVZViLW9w+sBNgeVYgXOYt3gnheH/ikf1i7eRa
	l0tR526z20fbwLzvn++EfsVZ7lM+qQIrPpys/j2Q1/RclApyWzQNhJQ2SzP1fZ5m6sdgKOznzBw
	RDi64XovEkLQ5zTvbFV6OOf6ZCQucQnN8AIPsDxL7Jbxajzf2PC2nZqAffKoZe1Im3+8DEcJLfm
	LALeXJYxq7jrOd5OAgmzGfK001ZGbniDd/QPqGSrK+kn7Pz0vqb6uk+BNTnGIGTAWV2RE1uLtt+
	A5puNMevkuN5E27pMBCEOgJximLPZzoUQdDoL/AO7WPzfJdad2Xa4HindIVd5xPkCN/We5Uf/gm
	PGrQARyjeerHDqLsjen58QdFaa33u5hR9QenksXtssEF8Bc9tcg80XGa8TjBg4F6B3d3GWclcrM
	VRejmD1c68oaneswuhks+fPITuL0JnKKBqKIkPa3lxxBCoJ4Ggp2l8O7EQayYuMBIvUK0=
X-Received: by 2002:a05:6808:d4d:b0:479:eb19:6e6a with SMTP id 5614622812f47-4824aa8d2e7mr5636779b6e.34.1778523744113;
        Mon, 11 May 2026 11:22:24 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c769c9b12sm20749141b6e.17.2026.05.11.11.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 11:22:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: defer linked-timeout chain splice out of hrtimer context
Date: Mon, 11 May 2026 12:21:03 -0600
Message-ID: <20260511182217.226763-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511182217.226763-1-axboe@kernel.dk>
References: <20260511182217.226763-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 466C9514649
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13269-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

io_link_timeout_fn() is the hrtimer callback that fires when a linked
timeout expires. It currently calls io_remove_next_linked(prev) under
ctx->timeout_lock to splice the timeout request out of the link chain.
This is the only chain-mutation site that runs without ctx->uring_lock,
because hrtimer callbacks cannot take a mutex. Defer the splicing until
the task_work callback.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/timeout.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e2595cae2b07..6353a4d979dc 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -284,6 +284,10 @@ static struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
 	struct io_timeout *timeout = io_kiocb_to_cmd(link, struct io_timeout);
 
 	io_remove_next_linked(req);
+
+	/* If this is NULL, then timer already claimed it and will complete it */
+	if (!timeout->head)
+		return NULL;
 	timeout->head = NULL;
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
 		list_del(&timeout->list);
@@ -367,6 +371,14 @@ static void io_req_task_link_timeout(struct io_tw_req tw_req, io_tw_token_t tw)
 	int ret;
 
 	if (prev) {
+		/*
+		 * splice the linked timeout out of prev's chain if the regular
+		 * completion path didn't already do it.
+		 */
+		if (prev->link == req)
+			prev->link = req->link;
+		req->link = NULL;
+
 		if (!tw.cancel) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
@@ -401,10 +413,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	/*
 	 * We don't expect the list to be empty, that will only happen if we
-	 * race with the completion of the linked work.
+	 * race with the completion of the linked work. Splice of prev is
+	 * done in io_req_task_link_timeout(), if needed.
 	 */
 	if (prev) {
-		io_remove_next_linked(prev);
 		if (!req_ref_inc_not_zero(prev))
 			prev = NULL;
 	}
-- 
2.53.0


