Return-Path: <io-uring+bounces-13031-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCpAO8m13Gm2VgkAu9opvQ
	(envelope-from <io-uring+bounces-13031-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 11:22:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5C23E9C7D
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 11:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D1E23023052
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 09:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DFD3B2FC7;
	Mon, 13 Apr 2026 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XO8rTa22"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7A83B19C1
	for <io-uring@vger.kernel.org>; Mon, 13 Apr 2026 09:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776072051; cv=none; b=ZdIVUlBkTcoQSQC922fcZdAQijbLbkJgvzZZ9AHUQmFDSskLjEl9AzvqaWMz5hNoUW8iUUXStESsDn0+UQu1/5C7pVtnw6YPq9YDr7SNTbqQr88FaJ/ZFwqBUPNrByjzWd34GaRyKr6jofxNWzOVeOs6CA2fQgEvlGhO4wXon3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776072051; c=relaxed/simple;
	bh=ZQbdW+pZRW5z6pWDy5eeu1tfL+8OP3e9D+SxOHbvNJw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZvZlZVsGPISqPgGxdam7aWkIZnLi8Zc2QWs7ZOjJgV56Z02Nb7yEskXbFuOTtPNFWMrq1GtRf9mEWuabYXw6z2PXjJkxGQSfmL8eysWAE9MuLKv5o4dzRxlqvur1FWpd6qpyHSfy+rIiuGVH5IRBA4XmBXzEquOYfd2wuQ3CtCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XO8rTa22; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48897fd88ebso45164165e9.2
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2026 02:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776072048; x=1776676848; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ax11sM/EYAPfFWrAhyNaXa7guBU55TLGndrpndn2rQQ=;
        b=XO8rTa223sWmOTjDmr2SzxtX2BD7BScupfRgISa/9YT0n1/AHahqYKdS3m8HxA8kkj
         euahbR7bVYvkujfckFD3zHnI6el41Ab90RqyVCFp3yAhbfmnp/8xytT3qvx0Z4HILRIm
         hEn4Oka43TH/eEwkRcsavAMklXUoIN/v4hGQAwiziqdL+pE+KLi0leqwFJ+4NQQLtmjO
         n46DbdlOUAa472szQpJjnoCL4yaYoLXEDIhbwn7O3/mKXzR48n1KHJAhEoRJZADGXqgN
         5ww3LCdjPpUiZ2iqOmT4EbAeGomZnyvROzcUb3tLxkabxuPx9uEBpUdLWVT3aCOxlEZe
         hQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776072048; x=1776676848;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ax11sM/EYAPfFWrAhyNaXa7guBU55TLGndrpndn2rQQ=;
        b=cDIaRK55NGwfqKDzkYFj2izFcTRxerwfyNpIjNgoeDEOXjiY5EJaMFmdqZWnByi6+F
         duf7+ZJnOxHaAcTSLX+o5THMCZ6IJu60vmeX8FHc0ytg+mhsPBi5aBvT/vG+bWf7aLUt
         grr6aICW0FZUtNYqh0XXebud0FT4WiTHMsrbfd3cXRw1jsfpZhBwds0mMTwp8k7C6BQb
         GXNrCbmeL755K/8ZNN1V4p4yEdJrTeNkmJPN5ShVy9wc8IgXO5g7iiEvZz1d/JTqQRrt
         AKEo2IkEuUNQRtzi1ENXZkGjeMuM1h1xnFonG2ri+uIBtIW99zvbnGHVNzsrqsL0u9Ga
         debA==
X-Gm-Message-State: AOJu0Yyy11UZdASvViKv5GJ7a7ynMwAvBTsnPRtJLMC3DXbyiN9uwP0M
	fqQGc27W3/3jv/29Uk2IeVAQM2Rne+qVKxvTPD72V+ajkJy0I+BGWJduwipzxA+t
X-Gm-Gg: AeBDiev1NHmcgN69IDgeaRQNJl5HY0OEC8l1bpUZtfYQISkfD3e0+DEG8LCia+7d9Rc
	BRTsOJrN7RiIO3R4RqFsciVJFvtQszuOcduFfdQxB5Qi8klwAX1I2EYaHs/D/1N5sySL5e1v4cg
	EORpCNMRtXM2aJ6kAXuLhHWfi3erZw/n+ByxyR5p8O5uqohj1YxXkyKGzKNHbzXkLHG69hbFxcF
	C4Pg2EtDaBYoKDOdOQE9RiAmagFPhSSlv3kVAE+MlXyK/r9QljPR2DzVfNFmvD/M/fa8i6H4GVa
	kmLdKI9qm00WA+rmlT9Uzv/aM5mdi2OHU2deOHBjgeZaV9pxiNpClJa7vmL/uh6i7i8mDU7/Yta
	MTFJEgPygv1stxnFlu+NY9EVnMycuX4xfxkp4qACcXmlrq5mTmqD0so576Pejdm4D32Ri+tNHqX
	qoVT/ST9L6IdfNjEU70OgF04PJvFzMYA==
X-Received: by 2002:a05:600c:34cd:b0:487:575:5e1 with SMTP id 5b1f17b1804b1-488d68c2cb4mr160396115e9.24.1776072048389;
        Mon, 13 Apr 2026 02:20:48 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67e7e45sm133603125e9.9.2026.04.13.02.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 02:20:47 -0700 (PDT)
Date: Mon, 13 Apr 2026 12:20:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring/tctx: clean up __io_uring_add_tctx_node()
 error handling
Message-ID: <ady1bB1t8l7LBjGG@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13031-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[error27@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,stanley.mountain:mid]
X-Rspamd-Queue-Id: 6C5C23E9C7D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Jens Axboe,

Commit 7880174e1e5e ("io_uring/tctx: clean up
__io_uring_add_tctx_node() error handling") from Apr 8, 2026
(linux-next), leads to the following Smatch static checker warning:

	io_uring/tctx.c:174 __io_uring_add_tctx_node()
	error: we previously assumed 'tctx->io_wq' could be null (see line 164)

io_uring/tctx.c
    139 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
    140 {
    141         struct io_uring_task *tctx = current->io_uring;
    142         int ret;
    143 
    144         if (unlikely(!tctx)) {
    145                 tctx = io_uring_alloc_task_context(current, ctx);
    146                 if (IS_ERR(tctx))
    147                         return PTR_ERR(tctx);
    148 
    149                 if (ctx->int_flags & IO_RING_F_IOWQ_LIMITS_SET) {
    150                         unsigned int limits[2] = { ctx->iowq_limits[0],
    151                                                    ctx->iowq_limits[1], };
    152 
    153                         ret = io_wq_max_workers(tctx->io_wq, limits);
    154                         if (ret)
    155                                 goto err_free;
    156                 }
    157         }
    158 
    159         /*
    160          * Re-activate io-wq keepalive on any new io_uring usage. The wq may have
    161          * been marked for idle-exit when the task temporarily had no active
    162          * io_uring instances.
    163          */
    164         if (tctx->io_wq)
                    ^^^^^^^^^^^
This assumes ->io_wq can be NULL

    165                 io_wq_set_exit_on_idle(tctx->io_wq, false);
    166 
    167         ret = io_tctx_install_node(ctx, tctx);
    168         if (!ret) {
    169                 current->io_uring = tctx;
    170                 return 0;
    171         }
    172         if (!current->io_uring) {
    173 err_free:
--> 174                 io_wq_put_and_exit(tctx->io_wq);
                                           ^^^^^^^^^^^
Dereferenced without checking

    175                 percpu_counter_destroy(&tctx->inflight);
    176                 kfree(tctx);
    177         }
    178         return ret;
    179 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

