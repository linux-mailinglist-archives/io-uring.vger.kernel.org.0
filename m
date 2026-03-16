Return-Path: <io-uring+bounces-12691-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMIuB+wIuGkWYQEAu9opvQ
	(envelope-from <io-uring+bounces-12691-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:43:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7518029AA52
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 946133004C56
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 13:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F64219C542;
	Mon, 16 Mar 2026 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROmQcO1f"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76881DE3B7
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773668305; cv=none; b=A5oiK0NJJD0cANRw4C20FI4hdZBz3ebNacuz8qGtqyysXoT3apumGqDmK4OpOoJObmVZ6giwgFF9NhksrvxMfEE/y0rZeY/xO6Yo8yLM9ymdibU4zE1P+PwnuWIZy3Wje+z68R/hG+EUts/+IQYw23Ky9eemJGmf+AhJJDm+544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773668305; c=relaxed/simple;
	bh=a7KNf7UtDflHtQCKuovuwZVeYv5zzwmUeFyTyYED/0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnevFPE4UXiuUe60EzLLtI7XxMM1SEqNmf6epbyNH9CfeFzgzMAS9ZkV9Gvt6eNOcC/EuTL8J4hVyl9pGQ6gq7NGe2g+/0VFwd9Hb/G5drjj6G7UA4PcUq0dbxdfWcN0yarDljhIhmaz7DlSg1n0R//sttG2F37LmIQWxNDM/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROmQcO1f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773668301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEGShbAMdcvWb7iMyf0WVzxtRHJfZ6y3446MjNTiLMk=;
	b=ROmQcO1feY/7Gv9lVzihAlk6WJL5u5Mr/MlaER/pl88OqUPDdlf0iFV9I+F21mhvWYElvM
	JinUKs3vSHlXL56aWyJV6umKS2409u7kLN0pq0QjdoDJkDKB9CCYa71Y79gOuOTkTBAiUd
	jRnjBVkXMfeZv6alwzhyremb8B9OkIk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-pyUa_yqEMz2jREGVjyILfQ-1; Mon,
 16 Mar 2026 09:38:20 -0400
X-MC-Unique: pyUa_yqEMz2jREGVjyILfQ-1
X-Mimecast-MFC-AGG-ID: pyUa_yqEMz2jREGVjyILfQ_1773668299
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 943C21956062;
	Mon, 16 Mar 2026 13:38:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.147])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D58719560AB;
	Mon, 16 Mar 2026 13:38:11 +0000 (UTC)
Date: Mon, 16 Mar 2026 21:38:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH V2 08/13] io_uring: bpf: add uring_bpf_memcpy() kfunc
Message-ID: <abgHvmnXgVquezKz@fedora>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
 <20260106101126.4064990-9-ming.lei@redhat.com>
 <CADUfDZqaM2cNn=QJzY1G912F5mX+Uhz5wTV4r3wvhAg-qhoBFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqaM2cNn=QJzY1G912F5mX+Uhz5wTV4r3wvhAg-qhoBFQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12691-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,samba.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7518029AA52
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 13, 2026 at 10:18:53PM -0700, Caleb Sander Mateos wrote:
> On Tue, Jan 6, 2026 at 2:12 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add uring_bpf_memcpy() kfunc that copies data between io_uring BPF
> > buffers. This kfunc supports all 5 buffer types defined in
> > io_bpf_buf_desc:
> >
> > - IO_BPF_BUF_USER: plain userspace buffer
> > - IO_BPF_BUF_FIXED: fixed buffer (absolute address within buffer)
> > - IO_BPF_BUF_VEC: vectored userspace buffer (iovec array)
> > - IO_BPF_BUF_KFIXED: kernel fixed buffer (offset-based addressing)
> > - IO_BPF_BUF_KVEC: kernel vectored buffer
> >
> > Add helper functions for buffer import:
> > - io_bpf_import_fixed_buf(): handles FIXED/KFIXED types with proper
> >   node reference counting
> > - io_bpf_import_kvec_buf(): handles KVEC using __io_prep_reg_iovec()
> >   and __io_import_reg_vec()
> > - io_bpf_import_buffer(): unified dispatcher for all buffer types
> > - io_bpf_copy_iters(): page-based copy between iov_iters
> >
> > The kfunc properly manages buffer node references and submit lock
> > for registered buffer access.
> 
> Ming,
> 
> Thank you for working on this patch series and sorry I didn't have a
> chance to take a look at this revision earlier.
> 
> My main reservation with this approach is that a dedicated kfunc is
> needed for each data manipulation operation an io_uring BPF program
> conceivably wants to perform. Even for the initial RAID parity
> calculation use case, I imagine we'd need a different kfunc for each
> RAID stripe data width and parity width combination. Other data
> operations added in the future would also need new kfuncs to support
> them.
> struct io_bpf_buf_desc is certainly more flexible than the approach in
> v1, but I worry that fully consuming the iterator in a single kfunc
> call prevents composing data operations during a single pass over the
> buffer. For example, if the input data needs to be encrypted and then
> parity needs to be generated over the encrypted data, calling an
> encryption kfunc and a parity generation kfunc in sequence would
> perform two passes over the data. To do it in a single pass, you'd
> need something like an "encrypt_and_gen_parity()" kfunc, which seems
> very niche.
> The hope was that io_uring BPF programs would provide a generic
> approach to registered buffer data manipulation, but the dependency on
> a large set of kfuncs seems a significant hurdle. I suspect a fully
> generic approach would require essentially reproducing the struct
> iov_iter abstraction in kfunc form.

Agree.

XOR/encrypt and copy should not be too hard to support if the kfunc interface
is well defined, and there is actually compression requirement in Android's use
case, which looks more complicated.

> 
> Here's an alternate idea I've been mulling over: could ublk devices
> implement the proposed user dma-buf abstraction
> (https://lore.kernel.org/io-uring/4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com/)?
> A client process could then pre-register its data pages as a dma-buf
> against a ublk device, which would provide a file handle to the ublk
> server for the dma-buf memory that it could mmap() into its address
> space. A ublk I/O using a dma-buf would be dispatched to the ublk
> server with the virtual address of the data buffer in the ublk
> server's address space. Then the ublk server could directly access the
> data buffer in userspace.
> From what I understand, this is similar to the original concept for
> ublk zero-copy, but with an additional pre-registration step. I think
> that may address the concern about mapping pages into the ublk
> server's address space in the I/O path. It would be an opt-in
> optimization for client applications, so it can require that the pages
> that will be shared with the ublk server are MAP_SHARED.

Yeah, I did look into Pavel's dma buffer based zc.

dma-buf is very handy to share everywhere, also it can avoid runtime
dma mapping. The only drawback is that client has to take dma-buf based
io-uring interface, so many application may not benefit from it.

Let's see how dma-buf related framework evolves.

Especially, for ublk, the focus is how to wire client dma buffer with
request buffer in ublk server side.

> 
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  io_uring/bpf_op.c | 320 +++++++++++++++++++++++++++++++++++++++++++++-
> >  io_uring/bpf_op.h |   3 +-
> >  2 files changed, 321 insertions(+), 2 deletions(-)
> >
> > diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
> > index d6f146abe304..3c577aa3dfc4 100644
> > --- a/io_uring/bpf_op.c
> > +++ b/io_uring/bpf_op.c
> > @@ -10,9 +10,11 @@
> >  #include <linux/btf.h>
> >  #include <linux/btf_ids.h>
> >  #include <linux/filter.h>
> > +#include <linux/uio.h>
> >  #include <uapi/linux/io_uring.h>
> >  #include "io_uring.h"
> >  #include "register.h"
> > +#include "rsrc.h"
> >  #include "bpf_op.h"
> >
> >  static inline unsigned char uring_bpf_get_op(u32 op_flags)
> > @@ -47,6 +49,7 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >
> >         data->opf = opf;
> >         data->ops = ops;
> > +       data->issue_flags = 0;
> >         ret = ops->prep_fn(data, sqe);
> >         if (!ret) {
> >                 /* Only increment refcount on success (uring_lock already held) */
> > @@ -74,7 +77,13 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
> >
> >  int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
> >  {
> > -       return __io_uring_bpf_issue(req);
> > +       struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
> > +       int ret;
> > +
> > +       data->issue_flags = issue_flags;
> > +       ret = __io_uring_bpf_issue(req);
> > +       data->issue_flags = 0;
> > +       return ret;
> >  }
> >
> >  void io_uring_bpf_fail(struct io_kiocb *req)
> > @@ -291,6 +300,235 @@ static struct bpf_struct_ops bpf_uring_bpf_ops = {
> >         .owner = THIS_MODULE,
> >  };
> >
> > +/*
> > + * Helper to copy data between two iov_iters using page extraction.
> > + * Extracts pages from source iterator and copies them to destination.
> > + * Returns number of bytes copied or negative error code.
> > + */
> > +static ssize_t io_bpf_copy_iters(struct iov_iter *src, struct iov_iter *dst,
> > +                                size_t len)
> > +{
> > +#define MAX_PAGES_PER_LOOP 32
> > +       struct page *pages[MAX_PAGES_PER_LOOP];
> > +       size_t total_copied = 0;
> > +       bool need_unpin;
> > +
> > +       need_unpin = iov_iter_extract_will_pin(src);
> > +
> > +       while (len > 0) {
> > +               struct page **page_array = pages;
> > +               size_t offset, copied = 0;
> > +               ssize_t extracted;
> > +               unsigned int nr_pages;
> > +               size_t chunk_len;
> > +               int i;
> > +
> > +               chunk_len = min_t(size_t, len, MAX_PAGES_PER_LOOP * PAGE_SIZE);
> > +               extracted = iov_iter_extract_pages(src, &page_array, chunk_len,
> > +                                                  MAX_PAGES_PER_LOOP, 0, &offset);
> > +               if (extracted <= 0) {
> > +                       if (total_copied > 0)
> > +                               break;
> > +                       return extracted < 0 ? extracted : -EFAULT;
> > +               }
> > +
> > +               nr_pages = DIV_ROUND_UP(offset + extracted, PAGE_SIZE);
> > +
> > +               for (i = 0; i < nr_pages && copied < extracted; i++) {
> > +                       size_t page_offset = (i == 0) ? offset : 0;
> > +                       size_t page_len = min_t(size_t, extracted - copied,
> > +                                               PAGE_SIZE - page_offset);
> > +                       size_t n;
> > +
> > +                       n = copy_page_to_iter(page_array[i], page_offset, page_len, dst);
> > +                       copied += n;
> > +                       if (n < page_len)
> > +                               break;
> > +               }
> > +
> > +               if (need_unpin)
> > +                       unpin_user_pages(page_array, nr_pages);
> > +
> > +               total_copied += copied;
> > +               len -= copied;
> > +
> > +               if (copied < extracted)
> > +                       break;
> > +       }
> > +
> > +       return total_copied;
> > +#undef MAX_PAGES_PER_LOOP
> > +}
> > +
> > +/*
> > + * Helper to import fixed buffer (FIXED or KFIXED).
> > + * Must be called with submit lock held.
> > + *
> > + * FIXED: addr is absolute userspace address within buffer
> > + * KFIXED: addr is offset from buffer start
> > + *
> > + * Returns node with incremented refcount on success, ERR_PTR on failure.
> > + */
> > +static struct io_rsrc_node *io_bpf_import_fixed_buf(struct io_ring_ctx *ctx,
> > +                                                   struct iov_iter *iter,
> > +                                                   const struct io_bpf_buf_desc *desc,
> > +                                                   int ddir)
> > +{
> > +       struct io_rsrc_node *node;
> > +       struct io_mapped_ubuf *imu;
> > +       int ret;
> > +
> > +       node = io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
> > +       if (!node)
> > +               return ERR_PTR(-EFAULT);
> > +
> > +       imu = node->buf;
> > +       if (!(imu->dir & (1 << ddir)))
> > +               return ERR_PTR(-EFAULT);
> 
> This is already checked in io_import_fixed()? Same comment for
> io_bpf_import_reg_vec().

OK.

> 
> > +
> > +       node->refs++;
> > +
> > +       ret = io_import_fixed(ddir, iter, imu, desc->addr, desc->len);
> > +       if (ret) {
> > +               node->refs--;
> 
> Just wait to increment node->refs until io_import_fixed() succeeds?
> Same comment for io_bpf_import_reg_vec().

Fine.

> 
> > +               return ERR_PTR(ret);
> > +       }
> > +
> > +       return node;
> > +}
> > +
> > +/*
> > + * Helper to import registered vectored buffer (KVEC).
> > + * Must be called with submit lock held.
> > + *
> > + * addr: userspace iovec pointer
> > + * len: number of iovecs
> > + * buf_index: registered buffer index
> > + *
> > + * Returns node with incremented refcount on success, ERR_PTR on failure.
> > + * Caller must call io_vec_free(vec) after use.
> > + */
> > +static struct io_rsrc_node *io_bpf_import_reg_vec(struct io_ring_ctx *ctx,
> > +                                                  struct iov_iter *iter,
> > +                                                  const struct io_bpf_buf_desc *desc,
> > +                                                  int ddir, struct iou_vec *vec)
> > +{
> > +       struct io_rsrc_node *node;
> > +       struct io_mapped_ubuf *imu;
> > +       int ret;
> > +
> > +       node = io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
> > +       if (!node)
> > +               return ERR_PTR(-EFAULT);
> > +
> > +       imu = node->buf;
> > +       if (!(imu->dir & (1 << ddir)))
> > +               return ERR_PTR(-EFAULT);
> > +
> > +       node->refs++;
> > +
> > +       /* Prepare iovec from userspace */
> > +       ret = __io_prep_reg_iovec(vec, u64_to_user_ptr(desc->addr),
> > +                                 desc->len, ctx->compat, NULL);
> > +       if (ret)
> > +               goto err;
> > +
> > +       /* Import vectored buffer from registered buffer */
> > +       ret = __io_import_reg_vec(ddir, iter, imu, vec, desc->len, NULL);
> > +       if (ret)
> > +               goto err;
> > +
> > +       return node;
> > +err:
> > +       node->refs--;
> > +       return ERR_PTR(ret);
> > +}
> > +
> > +/*
> > + * Helper to import a vectored user buffer (VEC) into iou_vec.
> > + * Allocates space in vec and copies iovec from userspace.
> > + *
> > + * Returns 0 on success, negative error code on failure.
> > + * Caller must call io_vec_free(vec) after use.
> > + */
> > +static int io_bpf_import_vec_buf(struct io_ring_ctx *ctx,
> > +                                struct iov_iter *iter,
> > +                                const struct io_bpf_buf_desc *desc,
> > +                                int ddir, struct iou_vec *vec)
> > +{
> > +       unsigned nr_vecs = desc->len;
> > +       struct iovec *iov;
> > +       size_t total_len = 0;
> > +       void *res;
> > +       int ret, i;
> > +
> > +       if (nr_vecs > vec->nr) {
> > +               ret = io_vec_realloc(vec, nr_vecs);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > +       iov = vec->iovec;
> > +       res = iovec_from_user(u64_to_user_ptr(desc->addr), nr_vecs,
> > +                             nr_vecs, iov, ctx->compat);
> > +       if (IS_ERR(res))
> > +               return PTR_ERR(res);
> > +
> > +       for (i = 0; i < nr_vecs; i++)
> > +               total_len += iov[i].iov_len;
> > +
> > +       iov_iter_init(iter, ddir, iov, nr_vecs, total_len);
> > +       return 0;
> > +}
> > +
> > +/*
> > + * Helper to import a buffer into an iov_iter based on io_bpf_buf_desc.
> > + * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, KVEC.
> > + * Must be called with submit lock held for FIXED/KFIXED/KVEC types.
> > + *
> > + * @ctx: ring context
> > + * @iter: output iterator
> > + * @desc: buffer descriptor
> > + * @ddir: direction (ITER_SOURCE for source, ITER_DEST for destination)
> > + * @vec: iou_vec for VEC/KVEC types (caller must call io_vec_free after use)
> > + *
> > + * Returns node pointer (may be NULL for USER/VEC), or ERR_PTR on failure.
> > + * Caller must drop node reference when done if non-NULL.
> > + */
> > +static struct io_rsrc_node *io_bpf_import_buffer(struct io_ring_ctx *ctx,
> > +                                                struct iov_iter *iter,
> > +                                                const struct io_bpf_buf_desc *desc,
> > +                                                int ddir, struct iou_vec *vec)
> > +{
> > +       int ret;
> > +
> > +       switch (desc->type) {
> > +       case IO_BPF_BUF_USER:
> > +               /* Plain user buffer */
> > +               ret = import_ubuf(ddir, u64_to_user_ptr(desc->addr),
> > +                                 desc->len, iter);
> > +               return ret ? ERR_PTR(ret) : NULL;
> > +
> > +       case IO_BPF_BUF_FIXED:
> > +       case IO_BPF_BUF_KFIXED:
> 
> Seems like these are handled identically, are both needed?

Yeah, but adding two could be more flexible.

> 
> > +               /* FIXED: addr is absolute address within buffer */
> > +               /* KFIXED: addr is offset from buffer start */
> > +               return io_bpf_import_fixed_buf(ctx, iter, desc, ddir);
> > +
> > +       case IO_BPF_BUF_VEC:
> > +               /* Vectored user buffer - addr is iovec ptr, len is nr_vecs */
> > +               ret = io_bpf_import_vec_buf(ctx, iter, desc, ddir, vec);
> > +               return ret ? ERR_PTR(ret) : NULL;
> > +
> > +       case IO_BPF_BUF_REG_VEC:
> > +               /* Registered vectored buffer */
> > +               return io_bpf_import_reg_vec(ctx, iter, desc, ddir, vec);
> > +
> > +       default:
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +}
> > +
> >  __bpf_kfunc_start_defs();
> >  __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
> >  {
> > @@ -300,10 +538,90 @@ __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
> >                 req_set_fail(req);
> >         io_req_set_res(req, res, 0);
> >  }
> > +
> > +/**
> > + * uring_bpf_memcpy - Copy data between io_uring BPF buffers
> > + * @data: BPF request data containing request context
> > + * @dst: Destination buffer descriptor
> > + * @src: Source buffer descriptor
> > + *
> > + * Copies data from source buffer to destination buffer.
> > + * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, REG_VEC.
> > + * The copy length is min of actual buffer sizes (for VEC types,
> > + * total bytes across all vectors, not nr_vecs).
> > + *
> > + * Returns: Number of bytes copied on success, negative error code on failure
> > + */
> > +__bpf_kfunc ssize_t uring_bpf_memcpy(const struct uring_bpf_data *data,
> > +                                    struct io_bpf_buf_desc *dst,
> > +                                    struct io_bpf_buf_desc *src)
> > +{
> > +       struct io_kiocb *req = cmd_to_io_kiocb((void *)data);
> 
> Could omit the explicit void * cast

OK.


Thanks, 
Ming


