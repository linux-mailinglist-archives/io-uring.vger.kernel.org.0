Return-Path: <io-uring+bounces-13238-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOSNCTnI+WlhEAMAu9opvQ
	(envelope-from <io-uring+bounces-13238-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 12:36:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 95ADA4CB83E
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 12:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E55731C2056
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 10:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2603EAC7F;
	Tue,  5 May 2026 10:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="VPPzpele"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B83F1667
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 10:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975814; cv=none; b=cOjPYHi8YVXB/DGW0skrQUvRiJIMcOerE4+v+bG36RUzQmBck4f5++/6XdSp0rxlvDinwHwFdGfwyimRY4pA04HDgCJvocEY99rXwZnPbncLBluF7yKwOT+/gIm0bZS3RAEZFqFGUMlsv46pI/3QIw9TRErfWDEJo8HGKqxqehs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975814; c=relaxed/simple;
	bh=9oqQH1qfBEJRuk3wVZzU0grvI3rXWRK4R2/ycR84m0E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PpLByvGyyr/T7GWvzZeeZb11UB+hXbSTqdaspnxHQgdsv0t46FhfF34Ie/L1ffWjgZA8P5rf2RGmNNGI0yza9Rj4mZ+aIqNAXVhpzl8yePvro9/tunSTz/aPh3B3iUjIs1isYenhDrCN52KFEA6Vc2xuJOiKe/hE8RZRNnzKDLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=VPPzpele; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso26990975e9.3
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 03:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777975801; x=1778580601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/o+0Q/X0If/4D+g3HwLBV72Px1O9IuGc0j7qaZ5M5bo=;
        b=VPPzpelezXdUYD2zI4l5xWQRttRvbafcp5a9moAt5UW7jCqa7LUmvtgGljI1l8atBs
         INEG9mRervTpLtVl83vFDRLhlsNujfjfwWxZEOpEBEv3wAFH08J0ACzyPsxD4Yx45Q/s
         ygkKrvV2wZegAa9DJhXVuLnwcbt2Wv85+0m53yrtEr73k9YGIrHAgMwV0kNyGXCdpuTD
         NenwdpK92Ih8MbPs999+UIbR+TJ8QvtC4eS7K8yDx5lrMPvGV0CeykhaFjJ+DMj6asod
         iojPZUY4Cu3sUX9DgE5xl+HVUSsvBbFN45egUKrLXtskD1i3XjX3PhSJ0r5uxwwi71xc
         jcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777975801; x=1778580601;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/o+0Q/X0If/4D+g3HwLBV72Px1O9IuGc0j7qaZ5M5bo=;
        b=RkWiDqdt1PXHpYXeD8OvvNI11FZqCz3pBklH+XIRW0nPQmq7ERneGQ3kAYnwGqhycj
         XssYp8c76qB/VAi/OPGWJcbRDB+D4Co071XJmFWrmY2AP5uhVlf6TDYiRNP82Dhx4xNF
         7HNjf7j2opte2/C6O1Vz8yVhL6YDzqgRYgs56fg1gU2WBlieU4BxlWCU4eMt+GMRtWGI
         sm1a9jMfKK/UTIANGRU83aPLc+I6xx3Ew5/lDq+r4rxj0OR+S9sUOE3Y/ITGfJGnDh4U
         /kxStlGYrXMKPLFpD0OBjTGrb47y3MlGcMgn690FZAk9MYbxSqu+uDN1S5N9/VJ91g1t
         xYHg==
X-Gm-Message-State: AOJu0YwBOqz7EtnAzwwbJ3OElfLW5c+XiZ/MpnXXezNhxazMLmILy2C3
	M1jrlHgcxaeB0nb+QsaQ04uXT/xDWfFYb374Sljib28D6ZnQTGTLWKxVp5qrwdTtuOkcCyv89un
	TS7Q53ww=
X-Gm-Gg: AeBDieu0ZVlBLhZogG6dFxk/Y+hNQV57+XSyan7+TBiGXhaU3lE49MMW1quSO5VDZl/
	cNOcUavOO9pj5OD5vaa9jdeQSl7b9F5dmQ4D1pIU1VZ4aPni9hxAZHpmoL8g5Hm+tIKZc2iIWol
	q0E/fZZ7PNN+IAAKfY8RQ/BqeDySddLqQXIc+GALX/uxvQAMOs5PoQpy972V/ildAoUbnzQ2KGa
	GaiNmUxf3KIyaqUcANfng/wCbZFyksao/lS3ZA0omf3zcCbdMKZa8q9cCRYw3PXeQeeqY3Gy4ji
	/sJvBic0omc+Tr1QbueyRNIDNP684THHr/oQdV1qQ5NUQaGCfK+R34tA1xEA9RqIuBo4r2l0nFd
	jta1+S00a1p/JNZpp7yzXZvy09QE9EY+KIzwPW5ClJJS41xRreKfUspDHGpsPcir5/lyJrqkvTn
	rRd4GPTQhRtSL7mf2p6AnzEzPNPZxSYLZnxPab3swxWknwR9VdMzL1UJ4urTh/6njihybN+uQgD
	utopRmtfUv/VQyubunE
X-Received: by 2002:a05:600c:5308:b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-48d03b401f5mr164940815e9.22.1777975798930;
        Tue, 05 May 2026 03:09:58 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d149ebdebsm21702645e9.4.2026.05.05.03.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 03:09:58 -0700 (PDT)
Message-ID: <3a19966b-229b-495b-966a-5018fc615a8a@kernel.dk>
Date: Tue, 5 May 2026 04:09:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: remove registered buffer 1GB limit
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
Cc: Andres Freund <andres@anarazel.de>
References: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
Content-Language: en-US
In-Reply-To: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95ADA4CB83E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13238-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]

On 5/5/26 1:39 AM, Jens Axboe wrote:
> There's no real reason to have a limit, as the memory is accounted by
> the lockmem limits anyway, if any exist. io_pin_pages() will still
> restrict the maximum allowed limit per buffer, which is INT_MAX
> number of pages. For a 4kb page size system, the limit is 8TB.
> 
> Reported-by: Andres Freund <andres@anarazel.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Forgot that I had a prep patch for this one... The branch is here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-reg-buffers

and notably the patch before this one is below, which bumps the ->len
size of the io_mapped_ubuf. I'll send this out as a proper series later
this week, this is 7.2 material obviously.

commit 381e736515173a1fb78d2a86983d3ebfcf263597
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon May 4 05:40:16 2026 -0600

    io_uring/rsrc: bump struct io_mapped_ubuf length field to size_t
    
    In preparation for supporting bigger individual buffers, bump the length
    field to a full 8-bytes with size_t rather than an unsigned int.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index c2d3e45544bb..f0ff4bd01b6d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -223,7 +223,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		if (ctx->buf_table.nodes[i])
 			buf = ctx->buf_table.nodes[i]->buf;
 		if (buf)
-			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
+			seq_printf(m, "%5u: 0x%llx/%zu\n", i, buf->ubuf, buf->len);
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 44e3386f7c1c..03521b50926c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -34,15 +34,15 @@ enum {
 
 struct io_mapped_ubuf {
 	u64		ubuf;
-	unsigned int	len;
+	size_t		len;
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
 	refcount_t	refs;
+	u8		flags;
+	u8		dir;
 	unsigned long	acct_pages;
 	void		(*release)(void *);
 	void		*priv;
-	u8		flags;
-	u8		dir;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 

-- 
Jens Axboe

