Return-Path: <io-uring+bounces-13337-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0B4mO83dBWokcgIAu9opvQ
	(envelope-from <io-uring+bounces-13337-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:35:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D165543362
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 968B5305044C
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3513DCDAB;
	Thu, 14 May 2026 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EIBUNeZa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56483EE1D4
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778768535; cv=pass; b=ZS5JxPiWLREc/5o3HvGflkDM8NU/fpOp4YqHU3bn2vqRqNC6lk597x3iWA9gJxzhVmJjCq4hG9FODvml9J7hCjiYHxHT7clTZFMkaUDlFtIlNML55QH4Q7N0t6q0v+Bo4OxVMLHiC/B+P90uxheQjeiOc8YSp4G+QXUhfofpi8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778768535; c=relaxed/simple;
	bh=9K6gKKan7Bbdsf/+y/CdBUXDGo5Hu7pwWqES8eXqXwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjrVBvghgRBjRLeWJs7kBC3P1b6Qt+hhz2JEozRsOS+6jW2o9T3AMEr6rkII48xWf53ht/PaS9Xzts7wwYd8W07CEefPDkFWhzJvY8TpAvhMReElsm904z3j8b/MaRHnKAv4In3dYKZvklurGjdGhEt6dY5Ovp5ufOZqnoJubd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EIBUNeZa; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6948c3fbbbbso334024eaf.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778768533; cv=none;
        d=google.com; s=arc-20240605;
        b=adb63TQduCTWmNwby074CYDGLqHS3KzqgEt7yI1Lk9bAG2yZj+JCOK/eTKANVy4RKC
         yNwr4ZViVwDT8s/7As+YZcFKO7/HsMx2SnVDfeon62Ne4gwHK7OXWk7eI2iKngNig39P
         ox40zS3SGGJ870NBejKlUziy7cWasAoIAfmdFj5xYOYEHK4KKMajvVUYuRjh3ZB1FthJ
         6RRb3r8G4x5lNyPf2JD6/hJP/Tbv69PIcN0leQWDc9gdBaYTN4T5+CJEZqzCsKsEKa2+
         TM3bAxopONJurgTfIoyq1jSplFq4BXa56+SRaBttnh1/1WM5uKC3K7WyCa0A+eOKCXkU
         DrIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5zF3Uy7JemBECg4vhkj0xdx/xhXmpBp1OIQYo+dR4qU=;
        fh=3pwlUg2Hlpg0kkzA4mPw9nzhsyS6L8oY/RDhq97OoBA=;
        b=AK0LOTxsygBN6R7fQdqQRb1f7b3vBaz1/GzTJUg2j2ShBpHodAQeCKkBfC13i9qIZH
         8sP7QiW+jViC9wusaUfRR1P5CQQGALiTvW70H4xlw/w3SwQqZMGGxweHRVlRLcAq3jUr
         a6lrVLL5LPmn0yj6Y+cBVl5Fev4HWpzVqPIvudxsQ2R8oqfMYviT/ftA85AVMdDShQrr
         mpnnctDMbpKs/GgD2RbKsAEIgn/q953xMboIgQA3elmwJjobpARbuFFhpi6/2Woe0RhJ
         eONhpTOD1p3Jdpfn+GXAkiK53r9O9XMex5WSBmNvHcLUIVYslK9xjEqMutXv02+5AV4J
         VvVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778768533; x=1779373333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zF3Uy7JemBECg4vhkj0xdx/xhXmpBp1OIQYo+dR4qU=;
        b=EIBUNeZaOuVQC6Yre+j+koKU9GujLySDaDaHtcHWkI8MVNZn8ShgvkRYVFQuNyIcc8
         JITezHywkjkvC3bmS7hE3j7Z1MLiIO/4mGRj1qF/V5MO99ScuOA9oBbFWQb5o65OKDay
         33n8TmaRFovicPB2WO5uuJGYFriliCvzzJE/4lGhDvl9gsiCSnCIUM/u1DJ9s+fTdkx/
         NviBE23bg9Abp3Dz9/NQNb2jk/ZjvZUFyNO8lcdTmZEdtNwk6N3KGjDQJnBc6d0+LqeJ
         FOvJc9EgkYgGpGLzlAjSjsY3m6c/CXxRxfSvE9i6twdSUGREQmWozC9/oss2NCMWM3al
         kzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778768533; x=1779373333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5zF3Uy7JemBECg4vhkj0xdx/xhXmpBp1OIQYo+dR4qU=;
        b=NbqDTWNY31lBJiYnTeXPpj5qi/1spJNa4JKh0zwFc2QrVao7s2k+rQbPAnvx3JTaCO
         zUaZpgyVfOOthiFyu6hvHbQliE4u7BjHQstj22o/f+zQvHEowiieEvw0yzCqZNG97JZz
         ELVrMepiIbirwcvhaoiZTwI0Rubfzy19WVVoV7H2fT7XaW/6f/1t2X9rudurwxEfjFIq
         AX2ne1kHAxVvXW6SOZ9NwEviygbVJciyqnhCLCFdqvPrvcSXYTC24+m+ZxHenCzEuVdw
         lHKRsQl16qTjwA/8dorFjKIpzNf/V+1gEhCYZgeXjjTiSy1n/R5NB4DP3L79IFkizxCW
         7kWA==
X-Gm-Message-State: AOJu0Yy01W4tDbhlcfZBfFUGL3VLTMEPw52/WWi9feU8NPjLmBjQLbcD
	5JU2t0w3zYPWjrL9Lk6cICiH2GxPC96jRSwgG6U4Y1/gvjXPcTwzXVnw05Oqpls+qdzd+lZeMXB
	cp61gmiBzULzwcu4wnf67AKDIKWIn3G9Y/2/KJlJQZXEeC7uIFoLlnbs=
X-Gm-Gg: Acq92OFxRKlYM4ZA9b7c1FL1+Gfl5O+OnZ8gXpjgQSUcZju+rNyB+x/vVfytMJ/ioPq
	UHtC6Z32si9SOiIis+1tW78xu8rLKhBpvrgCQkm3DcSCfuGllk+y06TmYh1aRLWLyz0WIQxqbFG
	/ZFRPyOkLAOohqTCAvrUVUL9LlQMJBvGDtSYkyKjbZE11mO33YouE/wdJYf7AQRUkN8Xx5BFr1O
	LloHC1f4uv3H0KMfRdkpU8mqcXoHy2kMbtO095UhUBHvlYnM9Oq4nw6G0dWyd4g5ISxqYG9D5+w
	owXITe27o7ttkMyUzow=
X-Received: by 2002:a05:6820:4ea3:b0:696:774f:420e with SMTP id
 006d021491bc7-69b78c5265dmr1853362eaf.0.1778768532518; Thu, 14 May 2026
 07:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514083443.203387-1-xieyi@kylinos.cn>
In-Reply-To: <20260514083443.203387-1-xieyi@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 14 May 2026 07:22:00 -0700
X-Gm-Features: AVHnY4JFCSsxmbLopGjwN85VS39Qc-1JFeDJiyb8Z-w9Ye8DlaF5SE-1twxwuN4
Message-ID: <CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
To: Yi Xie <xieyi@kylinos.cn>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D165543362
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13337-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,kylinos.cn:email]
X-Rspamd-Action: no action

On Thu, May 14, 2026 at 1:35=E2=80=AFAM Yi Xie <xieyi@kylinos.cn> wrote:
>
> Wrap the io_ring_head_to_buf() macro value in an extra pair of parenthese=
s
> so it is safe when composed into larger expressions, and to satisfy
> scripts/checkpatch.pl.
>
> Signed-off-by: Yi Xie <xieyi@kylinos.cn>
> ---
>  io_uring/kbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 63061aa1cab9..dd54e43e9ddf 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -21,7 +21,7 @@
>  #define MAX_BIDS_PER_BGID (1 << 16)
>
>  /* Mapped buffer ring, return io_uring_buf from head */
> -#define io_ring_head_to_buf(br, head, mask)    &(br)->bufs[(head) & (mas=
k)]
> +#define io_ring_head_to_buf(br, head, mask)    (&(br)->bufs[(head) & (ma=
sk)])

Is there a reason this can't just be an inline function?

Best,
Caleb

>
>  struct io_provide_buf {
>         struct file                     *file;
>

