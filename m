Return-Path: <io-uring+bounces-12669-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0B2iFc/vtGm/uQAAu9opvQ
	(envelope-from <io-uring+bounces-12669-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 06:19:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B901128BC72
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 06:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA43F3020EB4
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 05:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7042034EF11;
	Sat, 14 Mar 2026 05:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Jd5Oj+JI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6A61A9FAB
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 05:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465547; cv=pass; b=BXYME7q6bTT587QTja+Nn5Rmr+CKgV7VNE1XqQxGHj+F21pwiQd78mHOXtDV0rxUryTxVkw7EI17Dcft2Yf+hBtubw4XrgM0+zX8RMERL7iCbc6qlVvJm5OkXVtagQTzkdPDVKIiWh0DMtL8DnKOJ9yIN+pt9YhmkfMfFHuYmgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465547; c=relaxed/simple;
	bh=QhVIQhx7TqA6aDgjeX7gbaXboD/gP9x7k68eXxLwIfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=opEQ1pZ8xvvAyb75sPkuAFDijujFYqQWb0tCGj98gye0YuLkEVcpUXyrT2CzV48My+yFdBtFitpG8MjU62G2rkRvadneGm2NY486ofrf+jpXIZddNtHUDikkExCfyh2/ZJ83v6UV0mhTDs2jOWarmjOuKl6kkJaomnap0BGC2qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Jd5Oj+JI; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d73cd0ed7bso398746a34.0
        for <io-uring@vger.kernel.org>; Fri, 13 Mar 2026 22:19:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773465544; cv=none;
        d=google.com; s=arc-20240605;
        b=eeuqbttCxgGtxSYAf36QryLlWk5YhcFd4FU1vg8n55un+4F1ow4egFaiBddM9QEZzh
         Kh5cxbZZ/+2L9eVETaOvLLIjgCtjGb4zUzdhPfnorBt9iek+qVai6hYvgXj0SqlpwCN9
         9pojmzRB36/8DMJKqHVLSnalX52UeQQjmhLHLwPTlQXEaj1RIgbG9k0h2sOz1O1PwT1c
         Ok+aqFb2mUP6/JxoB88K43SIyeixtPt0tayKss+/XWioxWmuq/o05di9oIHhlPmqTSLb
         n7valR1eX0drpA6dJz8C40MXsK7FdWKUGH9O2S5lIq2xkVy4pJtmay9BdFAd28jXylfM
         g0gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vnozw+AEvulN2JwKIJpimwHVSukO4+gbOwJBbaxWDIM=;
        fh=Tq+q5jJgJjseHfcXSqsISsUhmelYHewtpg/eEX21UKM=;
        b=WjjxvmpGmClYIcPSDyUR3GBZ9VsSZrVy83UEfBUJY29ibZF7sG8b5IFPd6pmytA2FI
         mYr4kbZ4H5IokmapeQqOk04LfnIXb+MR2G+rwLwcddLPm3HNCJ8faZZ/Ytwfw/IEVXgd
         2d3y3mq9kBs91gmUsTr6y83NNft+3SS7lhUBbI19V2Fzakpn2bfLUR78MquJFGeFwT5k
         4FzZjWP62i1chCcgBw9spizr+SaCAg9q8C2PJCHKaxtsqj84RgnlA1ynpLJNtYIByKE1
         VcFqdsxbwcuoLAggXu6UQDfWrO5KjGU3qn4bA9kXLrWMLHeHUynOpYDGYGxO75trjEMF
         CVHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773465544; x=1774070344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnozw+AEvulN2JwKIJpimwHVSukO4+gbOwJBbaxWDIM=;
        b=Jd5Oj+JIltntvWfEKzGKET2pZR4OZD6H7WnplcThECu783Kp3Vr9I93e4F1JCJJ24o
         XiaQWagdwiTH7ss6A4967LXl4ZHJdLppBYmyf7iDqYCLeH/WT5pF0JxXAVyRAHpOUHuB
         gJvMyPUAAdSeGWJqi+pAh90W+4MKYsi5LzBeWFyogHS7A1SYjiQL5lNZkboGu0xgTtfP
         OUVW0jYZ950v4KaGLOeKoGEpOLM6xj4vJaZz/DQHDi2nNNlpXfHbNU7p1PzJOJ0cJ0r/
         sCd1FjEAew+PL82T4v2GzUm9AMNnPtZ7Q6xLWyOcWzDI2z/63Ta+YeqD1MSgTAiFeQtf
         97KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773465544; x=1774070344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vnozw+AEvulN2JwKIJpimwHVSukO4+gbOwJBbaxWDIM=;
        b=AdPU2ABSOtTMNUjAZIIK286lrJ9mzXb4JfAZF8JCh02GJOlmyRPoexHz/ZDzqMSsSd
         2DJdrtXZwKK7VeMbVzQShkv9vPoIRemhaynrCfXDoeFaux/52OSlDAWqAQRbvP/hqFCg
         nUHG++hjufHZAasFvwirEsxSGxr1WC2/QqVlwClnGokCK1wtJtCWElw6QI3iuv4wT4f2
         4Bti0FzpoqTqFRwp7zgD/mN4foOZSouYw9gSVcQsWOfkMqaKmLLP5HmICsZjsUX24cel
         quFv1B6L/YbigvUeA3yPV+a6Lkgko0hu/+Aaxg46WkgtEgeVqzoysJfUhkrymbKKP83k
         K0Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWzLHhQnmIIkRf+jM/KlW2F1Orotkhv2cTexI+Zkr5qLEMZkBzaAolU9D4k3j3GjLjtldsUAiy6Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz71dH2g9fHOYQAKBkVAFMxgxT7eaf+1Ni11vJBgzaA3mV6HfxT
	kKNzfU7FvGAoe1qfrNCtrdbXw1HbyvX2f4xw1wzfPUbYPOGt0Y+Rt4LBbPC0nwmAiuDV8Vkou6w
	JVdU27+3F8qqwvaGg0RDsSrseBIKXVLBc77HLWw6kug==
X-Gm-Gg: ATEYQzwxqObnCYX2kMrXz4VWo6Hq+aLnB8lQ7up+772L1rQC6l5W0m1X6GbFWLox7B5
	6teFOkwIi8cYp3PQe8P2OXBVhDtRfePpUnX+gTnaBNp/Luxo+yQgfMLFLsUCPh1Nyb1gg8h7hfo
	u8MQGYfRXdt7Wd+pdqwLXgYrqrj2HVWOvxVQhKOmGkc3oW579VyREUcEgj7GCL+prfqtwG0z+yP
	PPmClT1q9JLRNJj8lNxjULFFn+6QHX2TmUH5VoJEDkE1axL0IPhV0Xs1VppmAmwHKcHxiY3+wzM
	+jEPjrJk
X-Received: by 2002:a05:6830:4c08:b0:7d7:48fc:d991 with SMTP id
 46e09a7af769-7d7825c21e8mr3106119a34.4.1773465543853; Fri, 13 Mar 2026
 22:19:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101126.4064990-1-ming.lei@redhat.com> <20260106101126.4064990-9-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-9-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 13 Mar 2026 22:18:53 -0700
X-Gm-Features: AaiRm53y7Vl9GMyb7oJxrEOknnrJL5hjBmdrQblxTIXSF8TbakI6Dk0VTIE4GBU
Message-ID: <CADUfDZqaM2cNn=QJzY1G912F5mX+Uhz5wTV4r3wvhAg-qhoBFQ@mail.gmail.com>
Subject: Re: [PATCH V2 08/13] io_uring: bpf: add uring_bpf_memcpy() kfunc
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12669-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,samba.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: B901128BC72
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 6, 2026 at 2:12=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> Add uring_bpf_memcpy() kfunc that copies data between io_uring BPF
> buffers. This kfunc supports all 5 buffer types defined in
> io_bpf_buf_desc:
>
> - IO_BPF_BUF_USER: plain userspace buffer
> - IO_BPF_BUF_FIXED: fixed buffer (absolute address within buffer)
> - IO_BPF_BUF_VEC: vectored userspace buffer (iovec array)
> - IO_BPF_BUF_KFIXED: kernel fixed buffer (offset-based addressing)
> - IO_BPF_BUF_KVEC: kernel vectored buffer
>
> Add helper functions for buffer import:
> - io_bpf_import_fixed_buf(): handles FIXED/KFIXED types with proper
>   node reference counting
> - io_bpf_import_kvec_buf(): handles KVEC using __io_prep_reg_iovec()
>   and __io_import_reg_vec()
> - io_bpf_import_buffer(): unified dispatcher for all buffer types
> - io_bpf_copy_iters(): page-based copy between iov_iters
>
> The kfunc properly manages buffer node references and submit lock
> for registered buffer access.

Ming,

Thank you for working on this patch series and sorry I didn't have a
chance to take a look at this revision earlier.

My main reservation with this approach is that a dedicated kfunc is
needed for each data manipulation operation an io_uring BPF program
conceivably wants to perform. Even for the initial RAID parity
calculation use case, I imagine we'd need a different kfunc for each
RAID stripe data width and parity width combination. Other data
operations added in the future would also need new kfuncs to support
them.
struct io_bpf_buf_desc is certainly more flexible than the approach in
v1, but I worry that fully consuming the iterator in a single kfunc
call prevents composing data operations during a single pass over the
buffer. For example, if the input data needs to be encrypted and then
parity needs to be generated over the encrypted data, calling an
encryption kfunc and a parity generation kfunc in sequence would
perform two passes over the data. To do it in a single pass, you'd
need something like an "encrypt_and_gen_parity()" kfunc, which seems
very niche.
The hope was that io_uring BPF programs would provide a generic
approach to registered buffer data manipulation, but the dependency on
a large set of kfuncs seems a significant hurdle. I suspect a fully
generic approach would require essentially reproducing the struct
iov_iter abstraction in kfunc form.

Here's an alternate idea I've been mulling over: could ublk devices
implement the proposed user dma-buf abstraction
(https://lore.kernel.org/io-uring/4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmai=
l.com/)?
A client process could then pre-register its data pages as a dma-buf
against a ublk device, which would provide a file handle to the ublk
server for the dma-buf memory that it could mmap() into its address
space. A ublk I/O using a dma-buf would be dispatched to the ublk
server with the virtual address of the data buffer in the ublk
server's address space. Then the ublk server could directly access the
data buffer in userspace.
From what I understand, this is similar to the original concept for
ublk zero-copy, but with an additional pre-registration step. I think
that may address the concern about mapping pages into the ublk
server's address space in the I/O path. It would be an opt-in
optimization for client applications, so it can require that the pages
that will be shared with the ublk server are MAP_SHARED.

>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/bpf_op.c | 320 +++++++++++++++++++++++++++++++++++++++++++++-
>  io_uring/bpf_op.h |   3 +-
>  2 files changed, 321 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
> index d6f146abe304..3c577aa3dfc4 100644
> --- a/io_uring/bpf_op.c
> +++ b/io_uring/bpf_op.c
> @@ -10,9 +10,11 @@
>  #include <linux/btf.h>
>  #include <linux/btf_ids.h>
>  #include <linux/filter.h>
> +#include <linux/uio.h>
>  #include <uapi/linux/io_uring.h>
>  #include "io_uring.h"
>  #include "register.h"
> +#include "rsrc.h"
>  #include "bpf_op.h"
>
>  static inline unsigned char uring_bpf_get_op(u32 op_flags)
> @@ -47,6 +49,7 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
>
>         data->opf =3D opf;
>         data->ops =3D ops;
> +       data->issue_flags =3D 0;
>         ret =3D ops->prep_fn(data, sqe);
>         if (!ret) {
>                 /* Only increment refcount on success (uring_lock already=
 held) */
> @@ -74,7 +77,13 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
>
>  int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
>  {
> -       return __io_uring_bpf_issue(req);
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +       int ret;
> +
> +       data->issue_flags =3D issue_flags;
> +       ret =3D __io_uring_bpf_issue(req);
> +       data->issue_flags =3D 0;
> +       return ret;
>  }
>
>  void io_uring_bpf_fail(struct io_kiocb *req)
> @@ -291,6 +300,235 @@ static struct bpf_struct_ops bpf_uring_bpf_ops =3D =
{
>         .owner =3D THIS_MODULE,
>  };
>
> +/*
> + * Helper to copy data between two iov_iters using page extraction.
> + * Extracts pages from source iterator and copies them to destination.
> + * Returns number of bytes copied or negative error code.
> + */
> +static ssize_t io_bpf_copy_iters(struct iov_iter *src, struct iov_iter *=
dst,
> +                                size_t len)
> +{
> +#define MAX_PAGES_PER_LOOP 32
> +       struct page *pages[MAX_PAGES_PER_LOOP];
> +       size_t total_copied =3D 0;
> +       bool need_unpin;
> +
> +       need_unpin =3D iov_iter_extract_will_pin(src);
> +
> +       while (len > 0) {
> +               struct page **page_array =3D pages;
> +               size_t offset, copied =3D 0;
> +               ssize_t extracted;
> +               unsigned int nr_pages;
> +               size_t chunk_len;
> +               int i;
> +
> +               chunk_len =3D min_t(size_t, len, MAX_PAGES_PER_LOOP * PAG=
E_SIZE);
> +               extracted =3D iov_iter_extract_pages(src, &page_array, ch=
unk_len,
> +                                                  MAX_PAGES_PER_LOOP, 0,=
 &offset);
> +               if (extracted <=3D 0) {
> +                       if (total_copied > 0)
> +                               break;
> +                       return extracted < 0 ? extracted : -EFAULT;
> +               }
> +
> +               nr_pages =3D DIV_ROUND_UP(offset + extracted, PAGE_SIZE);
> +
> +               for (i =3D 0; i < nr_pages && copied < extracted; i++) {
> +                       size_t page_offset =3D (i =3D=3D 0) ? offset : 0;
> +                       size_t page_len =3D min_t(size_t, extracted - cop=
ied,
> +                                               PAGE_SIZE - page_offset);
> +                       size_t n;
> +
> +                       n =3D copy_page_to_iter(page_array[i], page_offse=
t, page_len, dst);
> +                       copied +=3D n;
> +                       if (n < page_len)
> +                               break;
> +               }
> +
> +               if (need_unpin)
> +                       unpin_user_pages(page_array, nr_pages);
> +
> +               total_copied +=3D copied;
> +               len -=3D copied;
> +
> +               if (copied < extracted)
> +                       break;
> +       }
> +
> +       return total_copied;
> +#undef MAX_PAGES_PER_LOOP
> +}
> +
> +/*
> + * Helper to import fixed buffer (FIXED or KFIXED).
> + * Must be called with submit lock held.
> + *
> + * FIXED: addr is absolute userspace address within buffer
> + * KFIXED: addr is offset from buffer start
> + *
> + * Returns node with incremented refcount on success, ERR_PTR on failure=
.
> + */
> +static struct io_rsrc_node *io_bpf_import_fixed_buf(struct io_ring_ctx *=
ctx,
> +                                                   struct iov_iter *iter=
,
> +                                                   const struct io_bpf_b=
uf_desc *desc,
> +                                                   int ddir)
> +{
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +       int ret;
> +
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
> +       if (!node)
> +               return ERR_PTR(-EFAULT);
> +
> +       imu =3D node->buf;
> +       if (!(imu->dir & (1 << ddir)))
> +               return ERR_PTR(-EFAULT);

This is already checked in io_import_fixed()? Same comment for
io_bpf_import_reg_vec().

> +
> +       node->refs++;
> +
> +       ret =3D io_import_fixed(ddir, iter, imu, desc->addr, desc->len);
> +       if (ret) {
> +               node->refs--;

Just wait to increment node->refs until io_import_fixed() succeeds?
Same comment for io_bpf_import_reg_vec().

> +               return ERR_PTR(ret);
> +       }
> +
> +       return node;
> +}
> +
> +/*
> + * Helper to import registered vectored buffer (KVEC).
> + * Must be called with submit lock held.
> + *
> + * addr: userspace iovec pointer
> + * len: number of iovecs
> + * buf_index: registered buffer index
> + *
> + * Returns node with incremented refcount on success, ERR_PTR on failure=
.
> + * Caller must call io_vec_free(vec) after use.
> + */
> +static struct io_rsrc_node *io_bpf_import_reg_vec(struct io_ring_ctx *ct=
x,
> +                                                  struct iov_iter *iter,
> +                                                  const struct io_bpf_bu=
f_desc *desc,
> +                                                  int ddir, struct iou_v=
ec *vec)
> +{
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +       int ret;
> +
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
> +       if (!node)
> +               return ERR_PTR(-EFAULT);
> +
> +       imu =3D node->buf;
> +       if (!(imu->dir & (1 << ddir)))
> +               return ERR_PTR(-EFAULT);
> +
> +       node->refs++;
> +
> +       /* Prepare iovec from userspace */
> +       ret =3D __io_prep_reg_iovec(vec, u64_to_user_ptr(desc->addr),
> +                                 desc->len, ctx->compat, NULL);
> +       if (ret)
> +               goto err;
> +
> +       /* Import vectored buffer from registered buffer */
> +       ret =3D __io_import_reg_vec(ddir, iter, imu, vec, desc->len, NULL=
);
> +       if (ret)
> +               goto err;
> +
> +       return node;
> +err:
> +       node->refs--;
> +       return ERR_PTR(ret);
> +}
> +
> +/*
> + * Helper to import a vectored user buffer (VEC) into iou_vec.
> + * Allocates space in vec and copies iovec from userspace.
> + *
> + * Returns 0 on success, negative error code on failure.
> + * Caller must call io_vec_free(vec) after use.
> + */
> +static int io_bpf_import_vec_buf(struct io_ring_ctx *ctx,
> +                                struct iov_iter *iter,
> +                                const struct io_bpf_buf_desc *desc,
> +                                int ddir, struct iou_vec *vec)
> +{
> +       unsigned nr_vecs =3D desc->len;
> +       struct iovec *iov;
> +       size_t total_len =3D 0;
> +       void *res;
> +       int ret, i;
> +
> +       if (nr_vecs > vec->nr) {
> +               ret =3D io_vec_realloc(vec, nr_vecs);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       iov =3D vec->iovec;
> +       res =3D iovec_from_user(u64_to_user_ptr(desc->addr), nr_vecs,
> +                             nr_vecs, iov, ctx->compat);
> +       if (IS_ERR(res))
> +               return PTR_ERR(res);
> +
> +       for (i =3D 0; i < nr_vecs; i++)
> +               total_len +=3D iov[i].iov_len;
> +
> +       iov_iter_init(iter, ddir, iov, nr_vecs, total_len);
> +       return 0;
> +}
> +
> +/*
> + * Helper to import a buffer into an iov_iter based on io_bpf_buf_desc.
> + * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, KVEC.
> + * Must be called with submit lock held for FIXED/KFIXED/KVEC types.
> + *
> + * @ctx: ring context
> + * @iter: output iterator
> + * @desc: buffer descriptor
> + * @ddir: direction (ITER_SOURCE for source, ITER_DEST for destination)
> + * @vec: iou_vec for VEC/KVEC types (caller must call io_vec_free after =
use)
> + *
> + * Returns node pointer (may be NULL for USER/VEC), or ERR_PTR on failur=
e.
> + * Caller must drop node reference when done if non-NULL.
> + */
> +static struct io_rsrc_node *io_bpf_import_buffer(struct io_ring_ctx *ctx=
,
> +                                                struct iov_iter *iter,
> +                                                const struct io_bpf_buf_=
desc *desc,
> +                                                int ddir, struct iou_vec=
 *vec)
> +{
> +       int ret;
> +
> +       switch (desc->type) {
> +       case IO_BPF_BUF_USER:
> +               /* Plain user buffer */
> +               ret =3D import_ubuf(ddir, u64_to_user_ptr(desc->addr),
> +                                 desc->len, iter);
> +               return ret ? ERR_PTR(ret) : NULL;
> +
> +       case IO_BPF_BUF_FIXED:
> +       case IO_BPF_BUF_KFIXED:

Seems like these are handled identically, are both needed?

> +               /* FIXED: addr is absolute address within buffer */
> +               /* KFIXED: addr is offset from buffer start */
> +               return io_bpf_import_fixed_buf(ctx, iter, desc, ddir);
> +
> +       case IO_BPF_BUF_VEC:
> +               /* Vectored user buffer - addr is iovec ptr, len is nr_ve=
cs */
> +               ret =3D io_bpf_import_vec_buf(ctx, iter, desc, ddir, vec)=
;
> +               return ret ? ERR_PTR(ret) : NULL;
> +
> +       case IO_BPF_BUF_REG_VEC:
> +               /* Registered vectored buffer */
> +               return io_bpf_import_reg_vec(ctx, iter, desc, ddir, vec);
> +
> +       default:
> +               return ERR_PTR(-EINVAL);
> +       }
> +}
> +
>  __bpf_kfunc_start_defs();
>  __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int r=
es)
>  {
> @@ -300,10 +538,90 @@ __bpf_kfunc void uring_bpf_set_result(struct uring_=
bpf_data *data, int res)
>                 req_set_fail(req);
>         io_req_set_res(req, res, 0);
>  }
> +
> +/**
> + * uring_bpf_memcpy - Copy data between io_uring BPF buffers
> + * @data: BPF request data containing request context
> + * @dst: Destination buffer descriptor
> + * @src: Source buffer descriptor
> + *
> + * Copies data from source buffer to destination buffer.
> + * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, REG_VEC.
> + * The copy length is min of actual buffer sizes (for VEC types,
> + * total bytes across all vectors, not nr_vecs).
> + *
> + * Returns: Number of bytes copied on success, negative error code on fa=
ilure
> + */
> +__bpf_kfunc ssize_t uring_bpf_memcpy(const struct uring_bpf_data *data,
> +                                    struct io_bpf_buf_desc *dst,
> +                                    struct io_bpf_buf_desc *src)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb((void *)data);

Could omit the explicit void * cast

Best,
Caleb

> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       unsigned int issue_flags =3D data->issue_flags;
> +       struct io_rsrc_node *src_node, *dst_node;
> +       struct iov_iter src_iter, dst_iter;
> +       struct iou_vec src_vec =3D {};
> +       struct iou_vec dst_vec =3D {};
> +       ssize_t ret;
> +       size_t len;
> +
> +       /* Validate buffer types */
> +       if (src->type > IO_BPF_BUF_REG_VEC || dst->type > IO_BPF_BUF_REG_=
VEC)
> +               return -EINVAL;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       /* Import source buffer */
> +       src_node =3D io_bpf_import_buffer(ctx, &src_iter, src, ITER_SOURC=
E,
> +                                       &src_vec);
> +       if (IS_ERR(src_node)) {
> +               ret =3D PTR_ERR(src_node);
> +               goto unlock;
> +       }
> +
> +       /* Import destination buffer */
> +       dst_node =3D io_bpf_import_buffer(ctx, &dst_iter, dst, ITER_DEST,
> +                                       &dst_vec);
> +       if (IS_ERR(dst_node)) {
> +               ret =3D PTR_ERR(dst_node);
> +               goto put_src;
> +       }
> +
> +       /*
> +        * Calculate copy length from actual iterator sizes.
> +        * For VEC types, desc->len is nr_vecs, not total bytes.
> +        */
> +       len =3D min(iov_iter_count(&src_iter), iov_iter_count(&dst_iter))=
;
> +       if (!len) {
> +               ret =3D 0;
> +               goto put_dst;
> +       }
> +       if (len > MAX_RW_COUNT) {
> +               ret =3D -EINVAL;
> +               goto put_dst;
> +       }
> +
> +       /* Copy data between iterators */
> +       ret =3D io_bpf_copy_iters(&src_iter, &dst_iter, len);
> +
> +put_dst:
> +       io_vec_free(&dst_vec);
> +       if (dst_node)
> +               io_put_rsrc_node(ctx, dst_node);
> +put_src:
> +       io_vec_free(&src_vec);
> +       if (src_node)
> +               io_put_rsrc_node(ctx, src_node);
> +unlock:
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return ret;
> +}
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(uring_bpf_kfuncs)
>  BTF_ID_FLAGS(func, uring_bpf_set_result)
> +BTF_ID_FLAGS(func, uring_bpf_memcpy)
>  BTF_KFUNCS_END(uring_bpf_kfuncs)
>
>  static const struct btf_kfunc_id_set uring_kfunc_set =3D {
> diff --git a/io_uring/bpf_op.h b/io_uring/bpf_op.h
> index 9de0606f5d25..6004fb906983 100644
> --- a/io_uring/bpf_op.h
> +++ b/io_uring/bpf_op.h
> @@ -13,10 +13,11 @@ struct uring_bpf_data {
>         void                            *req_data;  /* not for bpf prog *=
/
>         const struct uring_bpf_ops      *ops;
>         u32                             opf;
> +       u32                             issue_flags; /* io_uring issue fl=
ags */
>
>         /* writeable for bpf prog */
>         u8              pdu[64 - sizeof(void *) -
> -               sizeof(struct uring_bpf_ops *) - sizeof(u32)];
> +               sizeof(struct uring_bpf_ops *) - 2 * sizeof(u32)];
>  };
>
>  typedef int (*uring_bpf_prep_t)(struct uring_bpf_data *data,
> --
> 2.47.0
>

