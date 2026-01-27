Return-Path: <io-uring+bounces-11955-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qE5kHawaeWmPvQEAu9opvQ
	(envelope-from <io-uring+bounces-11955-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 21:06:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA679A32F
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 21:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 215E830214D0
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64381E7C34;
	Tue, 27 Jan 2026 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itJDAsDj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3DE2264C0
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769544360; cv=pass; b=EViLyK+424g8sTB3JcCIxWvr9vSZREzOSXQKzkGyueR230EZqfqNxS7dXU8kZozihOJ1/vL9gyIBnaBA1qpa/qEj709DRL94FenxeyG1sByeR7cB8LdqzMx612ik1DR3JedIOlLiVAyUnYp4TQZ3/vduWghU+azjYUCFHO6520E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769544360; c=relaxed/simple;
	bh=icI95fFOv3tMi/jB90IaeFcTs/ruZ0giOxBrLhXe7ds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FAsXezHipIxD9FcwtWY5AnV7EbW8KZxIMrlaT8uJcZ0PcyIJ3KAxOfAxbtrf6iKNby2y0CZQqp1D7EOSK1HFXqVHPF0i7bJY45NUX6qetSVG+EjY9S9e1SMGmWLNkngTRzjLlzgZX3rovC3gbYgJ4n9LYU8Io/4a7hCyC/wEcH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=itJDAsDj; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c5265d06c3so19632085a.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 12:05:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769544358; cv=none;
        d=google.com; s=arc-20240605;
        b=Asq3s5F4W1ZvRHkR1b+NKi24R9KSnb34ty8rFPidhNxYoXHr9/O3wlH8OqDk0NJWQY
         nMXbsk62LFdR/ZTE7Cu3x2nKjtgOtfi/sqAz55IztCPNzyJ+kCNSWXnLll8nHm3ZQ51E
         5y0fN5KT/Ek3Puo19E+eQylt5gp5d8jS9iJDfJzGzwGmMv98jUDOl5OLSLBbihHyFHrx
         xIWiRnegKQFAHtUimZocCF0D3SrE6MV2bjUh1eO8rzaqg+8xi8g1lcgwNLn3rC4VpMgl
         l7d0shHIb3qNocUax8QwRB7+2SH3d0EKdYA1DULxFRfLUswvSKg9a7KdmfVI5V4RHi3R
         HTRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CJsSVDxKTWVCl1kXW2ng0AR2wLLtclJzNKgDiXG68WY=;
        fh=xGebzUL2AadPpBjDqois4cjYuBTsF97mkjU33LCgW0c=;
        b=a9m5DNsD3ECY4OFFus9gRWadC/1xCmC+SS8Lu2QXcG5/EIoDZYx0ljBKyT21qDX9WW
         xkbLN29txtZA2qBsBqJvoqauGIkSfY6jJEG1Azjh0snkS7gYcgZdg/zUqggyV8mcgL03
         PSctwrxqNPqpGsBI4BtGJpXzXBgksu8edJB/+VDczFF6oGnuZD8FqStTv1pRXULucIeM
         rlrNNPjR3/wIARP1O+/In8g/TwrmROozJbW2TVu7OCzeewwh3He10dc+H37Vmqi4WbBG
         jmZnlNge6K+Ke0WKk6iSsreWbDkIs+9HANvyjEIhB8NUst+s3GH14TSs5+lhVmkjLx88
         2SNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769544358; x=1770149158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJsSVDxKTWVCl1kXW2ng0AR2wLLtclJzNKgDiXG68WY=;
        b=itJDAsDjNER9zIo2SgPy/pqPzKAeHVVwYHv9gJEeMso7MaRhv77F+lghpoaW8aXU6Z
         fOdmj5Ip30SOLzXb00WI2ZFxK2+X6OE7VsEP8noqOMNWZ5XawGDTV4Fvh7ALwV5dMdfP
         qS+uVmjas4zp25qHgVKHfE16QE0g/qeCMHvNKt9yJu0bQlUaZbfX6GSNAqCZHB893MFY
         bgNRVV9HHrSVaeOtOBeDgClxKWByX2o8BESE/eDyUds/6enzhalNQjpFUotk3Wngslw5
         p8EzVbA1wSQI1sEj1sApzUuc2gM89Zqf2jFKVPUBZMdl0y3tOlrlkt3K4HC/U6s35OmL
         4sow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769544358; x=1770149158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJsSVDxKTWVCl1kXW2ng0AR2wLLtclJzNKgDiXG68WY=;
        b=QRhdJB1W7DQYgAVVilzypPQOFEwC7igT+WuHFLQaHy8Wp8j7XNeYes2eu9qWL1nBTh
         YYLulUcBwQUwTfIA+yIFu+6kGuAdlb0b5vteAy6qLdnIHZp7JBLmrafFpHaLNC2W2piu
         stXyn4tbamDgImpgIjZ2yjT3dqCWWV94NU73sMvxvIRdKFJXDdbDxjqaYlERFYyR1nqj
         /iSaDtgxkmWDNJGdjNAdyRkA22hbb5LXuENWQZtjNuK3BVHWRy5FoWuUkFTlSYLAkklp
         4fpZg8pY4BgKmNoyNgujG4uCkHqjsb/xQ00DVjaGjwtOpBk2sFG0OJug1CE/YjJeLn4f
         ERiw==
X-Forwarded-Encrypted: i=1; AJvYcCXy+Q99EUSuWexxhQZOpn1/mc5VCkr0XM5aUOoNRWbpX7llai7H46PMX0AVVdBSvpqY9OWZXh3MiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu73ZxxJBZbbdkqiBoiegL24qLhNlHzlXHH3hbFwA1DYEEGMZe
	L8Ba7la5COmjDl/BHmAf5hKBc4EbPOZH3BXA49EvMkyTlC5qNIXEth+d088T5A3zr88P5vMm+Kb
	TqpOEku5dznDe2b+ZrRG26fhVup6S4nA=
X-Gm-Gg: AZuq6aLWfUXvrmT2HmpjWeaeKRLsRAuSkubU5Azr0bXUkRX2RnQ6zgwtfOYkHtiwua7
	eBNT8OExDr6usWzqJbCPcUtVvuxwc0BEhNM7jXW71964JUXz65XTlrkES5dIchTqG92Qt661Ekr
	zBQMZvuNn7yepMGJyY9xgfC9KB68b4bLVEk4ptcK+oNgid00ltBOM2yhZxmPzPXaW8Wr3krIzXf
	TUtiUxFmSEeTALSkalBjpvZary9jQT/uCNk1iI3XT66q4TmXu1oSwfACiRZ5fLLeBU4Bg==
X-Received: by 2002:a05:620a:44c4:b0:8b9:f737:2006 with SMTP id
 af79cd13be357-8c70c2252e8mr313395885a.37.1769544358324; Tue, 27 Jan 2026
 12:05:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-9-joannelkoong@gmail.com> <CADUfDZruYbRfpftns3a17HHF=ZqayztP-t5uVzSRB3APhree+Q@mail.gmail.com>
In-Reply-To: <CADUfDZruYbRfpftns3a17HHF=ZqayztP-t5uVzSRB3APhree+Q@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Jan 2026 12:05:46 -0800
X-Gm-Features: AZwV_Qhcl5kA2omf9KC3B_M0T2ItkthtaTdO1lT_2FU1UQX29xeLbA3n4-NE028
Message-ID: <CAJnrk1Z_73pVY6LsN33=LqcM5v1Z-w_uiUYb65bhFL3LiXXYxw@mail.gmail.com>
Subject: Re: [PATCH v4 08/25] io_uring: add io_uring_fixed_index_get() and io_uring_fixed_index_put()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com, krisman@suse.de, 
	io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com, 
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-11955-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: BBA679A32F
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 1:02=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Fri, Jan 16, 2026 at 3:31=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Add two new helpers, io_uring_fixed_index_get() and
> > io_uring_fixed_index_put(). io_uring_fixed_index_get() constructs an
> > iter for a fixed buffer at a given index and acquires a refcount on
> > the underlying node. io_uring_fixed_index_put() decrements this
> > refcount. The caller is responsible for ensuring
> > io_uring_fixed_index_put() is properly called for releasing the refcoun=
t
> > after it is done using the iter it obtained through
> > io_uring_fixed_index_get().
> >
> > The struct io_rsrc_node pointer needs to be returned in
> > io_uring_fixed_index_get() because the buffer at the index may be
> > unregistered/replaced in the meantime between this and the
> > io_uring_fixed_index_put() call. io_uring_fixed_index_put() takes in th=
e
> > struct io_rsrc_node pointer as an arg.
> >
> > This is a preparatory patch needed for fuse-over-io-uring support, as
> > the metadata for fuse requests will be stored at the last index, which
> > will be different from the buf index set on the sqe.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 20 ++++++++++++
> >  io_uring/rsrc.c              | 59 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 79 insertions(+)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 41c89f5c616d..fa41cae5e922 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1152,6 +1152,65 @@ int io_import_reg_buf(struct io_kiocb *req, stru=
ct iov_iter *iter,
> >         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
> >  }
> >
> > +struct io_rsrc_node *io_uring_fixed_index_get(struct io_uring_cmd *cmd=
,
> > +                                             int buf_index, unsigned i=
nt off,
> > +                                             size_t len, int ddir,
> > +                                             struct iov_iter *iter,
> > +                                             unsigned int issue_flags)
> > +{
> > +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +       struct io_rsrc_node *node;
> > +       struct io_mapped_ubuf *imu;
> > +       u64 addr;
> > +       int err;
> > +
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> > +       if (!node) {
> > +               io_ring_submit_unlock(ctx, issue_flags);
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +
> > +       node->refs++;
> > +
> > +       io_ring_submit_unlock(ctx, issue_flags);
> > +
> > +       imu =3D node->buf;
> > +       if (!imu) {
>
> How is this possible?

You're right, this null check is unnecessary. I'll drop it.

Thank you for reviewing the patches, Caleb.

>
> Other than that,
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
>
> > +               err =3D -EFAULT;
> > +               goto error;
> > +       }

