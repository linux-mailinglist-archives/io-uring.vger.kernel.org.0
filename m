Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716EB45636F
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 20:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKRTZy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 14:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhKRTZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 14:25:54 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01948C061574;
        Thu, 18 Nov 2021 11:22:54 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 206so1268164pgb.4;
        Thu, 18 Nov 2021 11:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9DwYPEuVSdd48njM32+CTEoTL5NcWu+kd/UXfUNYqNA=;
        b=PxoIvjhLE8yD5/colNf5+K2IUwNlaiSNkpSJhn92x7ZEAd5zKU/Kjk+YwoOI/d07x3
         RzxuH7OiR6s8l7DEtKrV9F3xTJ3FM6zkDxxKX4HNIdsped7obh9+5ZOKVTsrDcMGm90U
         eUYp+mXiQrcZy1zeVhTIMJ3Cd7+nNC1YQf9TvJoGFwZNwiyORVWpzH09loOw0LkXcCmh
         hHTqH9ICalJjO6bNLSjZwmc1hVGEoWwMZap4FHngnMxergk7At+A5+KDCAn2aL0VuZIj
         SKw7ouFSYETvynkd/byLw5dmo+CbvPrXkrT0joCorh/CBWEwZuSPeMI13UYjG9CTEBOu
         IDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9DwYPEuVSdd48njM32+CTEoTL5NcWu+kd/UXfUNYqNA=;
        b=B23LWfqkhLMS2r8OdOgPI2i35679HHxi2foriPT/EDaMZ5gXa1l51QI8MfZIOTlvcG
         r7gM7JCmkqo/Frb/jaRa+5ewX7a/+YQ6lg3CArl1PTxNcuqJ6yFkQ9oGj/kDlCUzLsM0
         CKBjTuWwdNmekKluVRO2bnwo104xU7g1xwCo6/7DksEIXgC68gRWj5ZZBcZyZgkDi9IP
         84vHNikFrMye/a235pDfxsPXaN4suUKDQyvtoRh7rU4J/Vpi5rmuAfXH2+2Ys6o8Q6MA
         YWg77fz+Ti968Zp7v/+mDRmrpYLYv/IB6W6YNi6l2lc30A0JIEK87DPJDhQdV5Iao/Dn
         SFew==
X-Gm-Message-State: AOAM5300kmOfZonCx5075TUh1AGZ8K+xmTj/dOOjaIql/TrLb+G5XkAe
        jdhGWmXLPIshKsqC9ibs1FY=
X-Google-Smtp-Source: ABdhPJx4J59KcZh//S44pDR3o7vIblqZR/9qmk8K0W5n2pI+QRJt6oHWMipVHSTfO0A/zLwp97S9wA==
X-Received: by 2002:a63:5961:: with SMTP id j33mr13068515pgm.56.1637263373511;
        Thu, 18 Nov 2021 11:22:53 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id g17sm370500pfv.136.2021.11.18.11.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 11:22:53 -0800 (PST)
Date:   Fri, 19 Nov 2021 00:52:50 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 2/8] bpf: Add bpf_page_to_pfn helper
Message-ID: <20211118192250.izzbajkorok6hvsv@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-3-memxor@gmail.com>
 <7efcf912-46be-1ed4-7e12-88c2baeaab12@fb.com>
 <20211118183022.tiijkhno57uwtytm@apollo.localdomain>
 <cdd2b65d-6be0-54b9-0c5f-1c425bc181c2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd2b65d-6be0-54b9-0c5f-1c425bc181c2@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 19, 2021 at 12:48:39AM IST, Yonghong Song wrote:
>
>
> On 11/18/21 10:30 AM, Kumar Kartikeya Dwivedi wrote:
> > On Thu, Nov 18, 2021 at 10:57:15PM IST, Yonghong Song wrote:
> > >
> > >
> > > On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> > > > In CRIU, we need to be able to determine whether the page pinned by
> > > > io_uring is still present in the same range in the process VMA.
> > > > /proc/<pid>/pagemap gives us the PFN, hence using this helper we can
> > > > establish this mapping easily from the iterator side.
> > > >
> > > > It is a simple wrapper over the in-kernel page_to_pfn helper, and
> > > > ensures the passed in pointer is a struct page PTR_TO_BTF_ID. This is
> > > > obtained from the bvec of io_uring_ubuf for the CRIU usecase.
> > > >
> > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > ---
> > > >    fs/io_uring.c                  | 17 +++++++++++++++++
> > > >    include/linux/bpf.h            |  1 +
> > > >    include/uapi/linux/bpf.h       |  9 +++++++++
> > > >    kernel/trace/bpf_trace.c       |  2 ++
> > > >    scripts/bpf_doc.py             |  2 ++
> > > >    tools/include/uapi/linux/bpf.h |  9 +++++++++
> > > >    6 files changed, 40 insertions(+)
> > > >
> > > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > > index 46a110989155..9e9df6767e29 100644
> > > > --- a/fs/io_uring.c
> > > > +++ b/fs/io_uring.c
> > > > @@ -11295,6 +11295,23 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
> > > >    	.seq_info	   = &bpf_io_uring_buf_seq_info,
> > > >    };
> > > > +BPF_CALL_1(bpf_page_to_pfn, struct page *, page)
> > > > +{
> > > > +	/* PTR_TO_BTF_ID can be NULL */
> > > > +	if (!page)
> > > > +		return U64_MAX;
> > > > +	return page_to_pfn(page);
> > > > +}
> > > > +
> > > > +BTF_ID_LIST_SINGLE(btf_page_to_pfn_ids, struct, page)
> > > > +
> > > > +const struct bpf_func_proto bpf_page_to_pfn_proto = {
> > > > +	.func		= bpf_page_to_pfn,
> > > > +	.ret_type	= RET_INTEGER,
> > > > +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> > > > +	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
> > >
> > > Does this helper need to be gpl_only?
>
> The typically guideline whether the same info can be retrieved from
> userspace. If yes, no gpl is needed. Otherwe, it needs to be gpl.
>

I think it can already be obtained using /proc/<PID>/pagemap, so not needed.

> Also, the helper is implemented in io_uring.c and the helper
> is used by tracing programs. Maybe we can put the helper
> in bpf_trace.c? The helper itself is not tied to io_uring, right?
>

Right, I'll move it outside CONFIG_IO_URING in v2. That's also why the build
failed on this patch.

--
Kartikeya
