Return-Path: <io-uring+bounces-11926-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LNmBgqyd2l2kQEAu9opvQ
	(envelope-from <io-uring+bounces-11926-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:27:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 572958C137
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C920330297A6
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 18:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5881C2F362A;
	Mon, 26 Jan 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KJHFTSBI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED3F346A01
	for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769452039; cv=none; b=RWEgSCNqCvQU8XvuvvJDkiSq03zZtcM3IvTJiuETYdMHo1BpGpXT95SeJB44Quey5D8tdmD93QxmdzdrOgmgYwItRA4GC9GLJQwsODp3w2+5MF5tH+GwkUI42IcLlXgyI4DzXbya8Z4LQUj7spmDHLOxmWQ9ODpFxyWt+aT2EN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769452039; c=relaxed/simple;
	bh=l7Q5lqV/NqRqfz3dBTV2Asfni7tAhiS5Lo+Tlk2qDCk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=LtMhfpQt/o+KHOIEc9BlmY511/sxO7HEbJXDx+hGUPZYq9HXFm3wH+qkKfYd0EuJZTX3OQ2ULv1MwqOK5YmZneC5oZDAVQgSCb99AXPsYz9zM4LdfJ+3aWHjNEJOsnyfDXLuWqTC5+nqrBFslP0Pn7qjlV8y+yIPLzGN+udpgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KJHFTSBI; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfcbf34124so3156518a34.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 10:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769452035; x=1770056835; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4EMtfOVYIKn7DlyQ3xzY48RmNg3aoV3AohMv6NmAQ0=;
        b=KJHFTSBIOfXtg/tS8MTxxT5/L83UnmkJ+jMslWFOxnV9/TdtLLdtFGox9cVQPp/HFH
         zuV235Bm7Z1xXk5VfwIEpv8fD46y7IydyiO2MU9ohJKQ1m62wD+a+TUWOZm0/s8D6ZMg
         mc9b5oqK1JLFvG9jUpZvqefvAREOanuYhTMVlnIZL4t8h3jTxrFR4uEhpqKDjjbdxE0K
         aXv9ARohtoEa8qzeCDDhfqnWETNX/yFHaF91XUx5KRNHvV9yLHlT5CKybJ8b/HhBpqrB
         yO+i4fFoOLhqZIhYFbuVJD4LIBEceqjpXp2zbxiVhBxJeaOQh/jyT2Pb24qmCSQ13wSq
         s4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769452035; x=1770056835;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I4EMtfOVYIKn7DlyQ3xzY48RmNg3aoV3AohMv6NmAQ0=;
        b=ZBUPn7ipyY64VCmY2DmWTtqr9LOBgC9vI60gbaS0UgXJyTn+RttQfWbbp1UWMQ5Ij+
         nppF8adLXImdgf/JEqnuss2aAYQrD59f0JYmSlInklsYC8XqP5rq03f114nFwU9erz5a
         rnlhDlwa0r9BclyEfkCLoqQqXSm/VLprSMosR1F/KzK6+LoEHKRyJm7yh6iMcakwG1Dm
         zHa+v4BZvzZU67JruRHTarHd55B5EeIK45snMRQ2Ih9CJBN84C94nQ6/GY8QoqW4hzKt
         Smou6BUgAjqnpptMRrl7GfmeLkiE141k5rKAPCQ0849ddvEdPl9FJ4XoazWT2X3TSNxf
         Gwpg==
X-Gm-Message-State: AOJu0YxN7QucBr5VrkmVsFn0yfoYXcqUXHOVhj0H27Q5S5j38WOHG9VN
	PK0cF4yqhyVES8TW4zDPtXcR4ANI8f2YdX8jLDYbMwQb6eZjAJLC8XVLFFYku+BFEGgb0e7scU1
	T4e5ySFs=
X-Gm-Gg: AZuq6aKlF71nrFX/3T+jDOiLAvo4nBhfihcBp5ebngU/hhPsou4KVyQnRBNZ0A8a/nx
	5xfB5j6gQg1jzGN73R+5awFf0WYI6kBnr/iR7vhMvGl8ocPxTnKAEEfgXx4E0PMIFiHrUWFGy4v
	refppTToMBDAfGZgPBd7IxwyDVSG6k8iFr3CfiKoH6c1aE7B8xeDgaPCQ8A9v0RyWwKOWFNJH7T
	jA5Vbh9KTaRobod7rcxaQz7KbFOOMTHBH2hKwMA8jzI+vzpoXe9V3sQDc2kqKtJNUCy0+mOgeqf
	jt1Jl7wHZCFxNaJtK3d/14Dlu3V1NyT+sgG5MqxguVtfWIGSMkI4GtsQP1THtybrt5lbPNJr9rA
	Q7BN0xgma4qhTI89BlQOR7QzSq/gSSCjQJG/xZr5n0QgKf+2HV5nA4OFnIIWf72orPA3izMQ48c
	ND4zpqwyCqypcwuQX5+zAw0KgzZxxemfZ5qGkWgpxnqpU6BwbKY4l9V26j/p21AC/ZXhC2aQ==
X-Received: by 2002:a05:6830:2404:b0:7d1:4980:2543 with SMTP id 46e09a7af769-7d17026ed3dmr2510097a34.27.1769452035052;
        Mon, 26 Jan 2026 10:27:15 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b346e35sm8321771a34.5.2026.01.26.10.27.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 10:27:14 -0800 (PST)
Message-ID: <77fa6cab-2e09-4ae6-a70e-fe9cfeec3f49@kernel.dk>
Date: Mon, 26 Jan 2026 11:27:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/kbuf: don't early commit provided ring buffers if
 locked
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11926-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 572958C137
X-Rspamd-Action: no action

If multiple buffers are peeked, they need not get committed upfront if
the caller has the uring_lock held - for that case, rely on the caller
recycling or committing before dropping the lock. This can happen if the
operation fails and needs to punt to polling, for example.

Link: https://github.com/axboe/liburing/discussions/1528
Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: forgot to refresh patch, the commit needs to be under the
    IO_URING_F_UNLOCKED section too of course.

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 796d131107dd..27c190c5bb5f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -328,15 +328,17 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (sel->buf_list->flags & IOBL_BUF_RING) {
 		ret = io_ring_buffers_peek(req, arg, sel->buf_list);
 		/*
-		 * Don't recycle these buffers if we need to go through poll.
-		 * Nobody else can use them anyway, and holding on to provided
-		 * buffers for a send/write operation would happen on the app
-		 * side anyway with normal buffers. Besides, we already
-		 * committed them, they cannot be put back in the queue.
+		 * Allow recyling of these buffers only if we arrived here
+		 * in a locked state. That relies on the caller doing the
+		 * proper recycling under the lock, if it doesn't commit under
+		 * the lock.
 		 */
 		if (ret > 0) {
-			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
+			req->flags |= REQ_F_BUFFERS_COMMIT;
+			if (issue_flags & IO_URING_F_UNLOCKED) {
+				req->flags |= REQ_F_BL_NO_RECYCLE;
+				io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
+			}
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);

-- 
Jens Axboe


