Return-Path: <io-uring+bounces-8310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4165AD65D9
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 04:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FB161BC18CA
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 02:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE2D1C6FE9;
	Thu, 12 Jun 2025 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYS5Rlpn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE61C1F13;
	Thu, 12 Jun 2025 02:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749696485; cv=none; b=dUOY9Hl80evHkeQxW2rYj4KRRvyJo2KtwSWtMu4QcpoGl+rb/P/VgZeydLzfOo3b3W5mC7MNYJki4+mrI02+Wu3RUAhQs/4aQd3eKD23xRrimGaxgw3Bj5KCfi9oZ9rlKJy5UQY4ggWNuthqxZWZMhSyqGFR+bKrgRMB+AsnkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749696485; c=relaxed/simple;
	bh=f4H7Y+r48HQSZ7EuN5UKYiS6BVNKq79Svws0Lv+F8LI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NGDbAY9KRqMdMEk6CUAIbC0ZGmWyLyhOYWUeY6FFa3ZAOF7a/7Cw5OhMKbq8IV4u8+rYlrKAzVc2rg0IZygA5SgiuwpHDzc1iJejqsl7VS2ZrhDdff0hP0Wiei3rGH66eDkbo/ll8TyXzGBZyRxOi1pjyJKc6/IiY7zPjjtXCJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYS5Rlpn; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a53359dea5so313684f8f.0;
        Wed, 11 Jun 2025 19:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749696482; x=1750301282; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vz148ZUApP4uOQdhUfpaPucEXS8RXsBePf4DAtP/7aA=;
        b=MYS5Rlpnor2/MvAa36QmSikd+Wh3IfhnQrf5mKpflRLvfEMuXWPOIxwvL9Zx0mq+2l
         hrbvXTlr2mBaxfDRV4vGyzEMw702GLdyIv/nUqnXf0RQejYXy0FsCgYynMZPoatb9aDI
         po39TTl4Olh3i7ikqU8eUOI0XcGzR5I7kfd7nESJZP4gMO8LdUrkWvhIEGhOBlYYshzZ
         4wFgentpGZFq5ODhvzBHqGjy1rO4qrX8MBYtGPzch0ebuoHScR0gsdW2BP1P/SQ3lYeB
         dD+usiIKUEH9w+MgxUPjVDLNkaYTViJuJlTaRz9IYBbYxGPQU8IFjO7Kji4Nq7+Mr6Ic
         lYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749696482; x=1750301282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vz148ZUApP4uOQdhUfpaPucEXS8RXsBePf4DAtP/7aA=;
        b=fmkInfJqicJiULxw3BGf4mhMX6oyJuVdB8rV7wO3aQ/Sx3rjwc33c9D/YpFmrzHZiA
         sQ2XdNn7diQAaDnPBJoueLfXWosH1WXBeMrHaXWU399j2YnK0rbsSUmpfFuIo4HlPauP
         cjerbgx9Adbm0vHX+UkGJuafJbnlMEv09qbE8r/tYIwIZBWbcaVPE9k8Pc7hWIFEXRfh
         uAxOpVBBhoQf4+GSwS7YE4K9UQmSojWlnmQa2NcnlVsFwMLLSwfe4xyGYYeKQFZ6AwUW
         Q3jpoaDVs1/QaAkZaiGKmAaDglzME4lg27X56m1Vt3bX2LJAFRUmCyHhgD6lRH9cdorf
         cN3g==
X-Forwarded-Encrypted: i=1; AJvYcCUFxwJ2WXxgS3Xyy2AxH8ahBis6KAKHR5CP9nzpjk1+XVgX5SBNQNfJHQVxqPgT1z2RbzZrg+StRR3hwmcs@vger.kernel.org, AJvYcCWj2WKp1dbvjCEwEXptYfw+1ahNzPqT/C9EqlcRk1bGnJ4GbLApYXF6HXMnzcm040QPaJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YypeSmdUQ76oHn4S2+TJfzrE1rJquQabjo8eOTyVD3EcfRb6Onm
	ONUXbfc9g7q40gRrhbppLlLSqUHogmw2XN8FobzxSxbdwYJJF/xpdH9dVBK3RidmaRCyilkN0qE
	beEysucB21OEeOwJ1kdU+8TUSABmQAW8=
X-Gm-Gg: ASbGncsxJB8omhMfEz5nIDxdokSGIP40MH+SUgtLSXMZUAAqn90rLNRkAZrmvA45uFu
	XVTTkFSPMI4EzdI25sb5dwFQzgncezPAwmbWqtOoFPDsSt7AAj16M53LKZcUobvw/ipiFm6NuFr
	FmzFLz/5y0es5lYAikk/Gcu2h4JhEdMb5loCF4JLk8ptc33IKjQYjC2pa+WX5xJYcTxikxDdpT
X-Google-Smtp-Source: AGHT+IG0h9jaSAfIckQc+5yClXVhCcGIYDKsgqCETtZ4Rmbkq6wPTIOJFNrLjX1KFcb3wWcy6w1fBUfp7W4VGxZonhY=
X-Received: by 2002:a05:6000:18a8:b0:3a4:e6d7:6160 with SMTP id
 ffacd0b85a97d-3a5612f0b3dmr713407f8f.6.1749696481781; Wed, 11 Jun 2025
 19:48:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749214572.git.asml.silence@gmail.com> <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
In-Reply-To: <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 11 Jun 2025 19:47:50 -0700
X-Gm-Features: AX0GCFsF8TengxXbdw4Na3vitrpKct7_UfoZ8uTTIUrWlnDfIh3GU3rfFF7cuWg
Message-ID: <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 6:58=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> A handle_events program should be able to parse the CQ and submit new
> requests, add kfuncs to cover that. The only essential kfunc here is
> bpf_io_uring_submit_sqes, and the rest are likely be removed in a
> non-RFC version in favour of a more general approach.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/bpf.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
>
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index f86b12f280e8..9494e4289605 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -1,12 +1,92 @@
>  #include <linux/mutex.h>
>  #include <linux/bpf_verifier.h>
>
> +#include "io_uring.h"
>  #include "bpf.h"
>  #include "register.h"
>
>  static const struct btf_type *loop_state_type;
>  DEFINE_MUTEX(io_bpf_ctrl_mutex);
>
> +__bpf_kfunc_start_defs();
> +
> +__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx,
> +                                        unsigned nr)
> +{
> +       return io_submit_sqes(ctx, nr);
> +}
> +
> +__bpf_kfunc int bpf_io_uring_post_cqe(struct io_ring_ctx *ctx,
> +                                     u64 data, u32 res, u32 cflags)
> +{
> +       bool posted;
> +
> +       posted =3D io_post_aux_cqe(ctx, data, res, cflags);
> +       return posted ? 0 : -ENOMEM;
> +}
> +
> +__bpf_kfunc int bpf_io_uring_queue_sqe(struct io_ring_ctx *ctx,
> +                                       void *bpf_sqe, int mem__sz)
> +{
> +       unsigned tail =3D ctx->rings->sq.tail;
> +       struct io_uring_sqe *sqe;
> +
> +       if (mem__sz !=3D sizeof(*sqe))
> +               return -EINVAL;
> +
> +       ctx->rings->sq.tail++;
> +       tail &=3D (ctx->sq_entries - 1);
> +       /* double index for 128-byte SQEs, twice as long */
> +       if (ctx->flags & IORING_SETUP_SQE128)
> +               tail <<=3D 1;
> +       sqe =3D &ctx->sq_sqes[tail];
> +       memcpy(sqe, bpf_sqe, sizeof(*sqe));
> +       return 0;
> +}
> +
> +__bpf_kfunc
> +struct io_uring_cqe *bpf_io_uring_get_cqe(struct io_ring_ctx *ctx, u32 i=
dx)
> +{
> +       unsigned max_entries =3D ctx->cq_entries;
> +       struct io_uring_cqe *cqe_array =3D ctx->rings->cqes;
> +
> +       if (ctx->flags & IORING_SETUP_CQE32)
> +               max_entries *=3D 2;
> +       return &cqe_array[idx & (max_entries - 1)];
> +}
> +
> +__bpf_kfunc
> +struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx *c=
tx)
> +{
> +       struct io_rings *rings =3D ctx->rings;
> +       unsigned int mask =3D ctx->cq_entries - 1;
> +       unsigned head =3D rings->cq.head;
> +       struct io_uring_cqe *cqe;
> +
> +       /* TODO CQE32 */
> +       if (head =3D=3D rings->cq.tail)
> +               return NULL;
> +
> +       cqe =3D &rings->cqes[head & mask];
> +       rings->cq.head++;
> +       return cqe;
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(io_uring_kfunc_set)
> +BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
> +BTF_ID_FLAGS(func, bpf_io_uring_post_cqe, KF_SLEEPABLE);
> +BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
> +BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
> +BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
> +BTF_KFUNCS_END(io_uring_kfunc_set)

This is not safe in general.
The verifier doesn't enforce argument safety here.
As a minimum you need to add KF_TRUSTED_ARGS flag to all kfunc.
And once you do that you'll see that the verifier
doesn't recognize the cqe returned from bpf_io_uring_get_cqe*()
as trusted.
Looking at your example:
https://github.com/axboe/liburing/commit/706237127f03e15b4cc9c7c31c16d34dbf=
f37cdc
it doesn't care about contents of cqe and doesn't pass it further.
So sort-of ok-ish right now,
but if you need to pass cqe to another kfunc
you would need to add an open coded iterator for cqe-s
with appropriate KF_ITER* flags
or maybe add acquire/release semantics for cqe.
Like, get_cqe will be KF_ACQUIRE, and you'd need
matching KF_RELEASE kfunc,
so that 'cqe' is not lost.
Then 'cqe' will be trusted and you can pass it as actual 'cqe'
into another kfunc.
Without KF_ACQUIRE the verifier sees that get_cqe*() kfuncs
return 'struct io_uring_cqe *' and it's ok for tracing
or passing into kfuncs like bpf_io_uring_queue_sqe()
that don't care about a particular type,
but not ok for full tracking of objects.

For next revision please post all selftest, examples,
and bpf progs on the list,
so people don't need to search github.

