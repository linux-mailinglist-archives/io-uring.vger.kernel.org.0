Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C362456263
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 19:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhKRSdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 13:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhKRSda (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 13:33:30 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC3BC061574;
        Thu, 18 Nov 2021 10:30:30 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so6516513pjb.1;
        Thu, 18 Nov 2021 10:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mmspkO1+kPp2+rBfPcrNFF0KAZ/yEbitomitKki1F4c=;
        b=XRtmBkzOuEkF7fbB19qsHET67f9ylIAhemTwj0vY9oKXWLr9hCB0cwV+nxw8o2stj0
         GltcY7l2K5tONJxOquuV7L2TIN57YZJrJmw7y9PV9ZxF0ZLwEjheWjRBvyQhzmVakSrk
         PbDgBSWiH91ite0gOJlgdbDos1H/0AYsxt2RGlhNvwycoZcUQ6/5iz07sd69JTksW/Iu
         +KaHny4SmGhvAWhoVrGJDNvyfNKpVutlqmFg5PWkDtRMjSY0X0HX4B6ljRB8eyWlOBva
         Q0x63QNi0e41C925oVbGx5yJCGJ/Ts+/GgDZVJZwl6lisD3Uen2AEJM2XOPa6z9J/iRH
         arLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mmspkO1+kPp2+rBfPcrNFF0KAZ/yEbitomitKki1F4c=;
        b=jYzJc5al2quDchjICknZ9AyViaWq420CaWEojwc0pBxXnVZNkK+nyo0GEfQPErRIz+
         0ZDtsi3jqOHaK1tfCe4nRy3g9u1GI/cfAgzonR8ZQYBIOysfnbNTaEsOFIh3tUg1l5Ox
         +yjTEeCGwTMlwggJAYi48/Umr3ghtWLahQUy/qbapjES3Qx0Gj/v0i5qhjL4Xzixqzka
         tuCE+nosXxkf6TOMc0GGIKaFdxr/Tb4phoRssUC3Dvm8YIEu9mC1C15nhdgLbFBRgWDT
         f9CctW1EYBlUkdkDYXCqdQ9pikdY4vGGhoASayP1DPqj02t4wGDcNZgPS005sRbglpMS
         8aWQ==
X-Gm-Message-State: AOAM5316ENLESkN6XV/FM6lsj/aptRvu1nrQEF1vcor+esZLu7FbCKJK
        q1NxaMKy9NfUOpRTFQj2Qu8=
X-Google-Smtp-Source: ABdhPJz9wj7HKK9knl1Ytfr+vDJMKwINA2ORQdacsublH0aSjcqqJiK6TuFVyzwadYh7BoK0c10X1w==
X-Received: by 2002:a17:902:c145:b0:142:50c3:c2a with SMTP id 5-20020a170902c14500b0014250c30c2amr68183395plj.32.1637260229980;
        Thu, 18 Nov 2021 10:30:29 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id u2sm293799pfi.120.2021.11.18.10.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:30:29 -0800 (PST)
Date:   Fri, 19 Nov 2021 00:00:22 +0530
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
Message-ID: <20211118183022.tiijkhno57uwtytm@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-3-memxor@gmail.com>
 <7efcf912-46be-1ed4-7e12-88c2baeaab12@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efcf912-46be-1ed4-7e12-88c2baeaab12@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 18, 2021 at 10:57:15PM IST, Yonghong Song wrote:
>
>
> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> > In CRIU, we need to be able to determine whether the page pinned by
> > io_uring is still present in the same range in the process VMA.
> > /proc/<pid>/pagemap gives us the PFN, hence using this helper we can
> > establish this mapping easily from the iterator side.
> >
> > It is a simple wrapper over the in-kernel page_to_pfn helper, and
> > ensures the passed in pointer is a struct page PTR_TO_BTF_ID. This is
> > obtained from the bvec of io_uring_ubuf for the CRIU usecase.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   fs/io_uring.c                  | 17 +++++++++++++++++
> >   include/linux/bpf.h            |  1 +
> >   include/uapi/linux/bpf.h       |  9 +++++++++
> >   kernel/trace/bpf_trace.c       |  2 ++
> >   scripts/bpf_doc.py             |  2 ++
> >   tools/include/uapi/linux/bpf.h |  9 +++++++++
> >   6 files changed, 40 insertions(+)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 46a110989155..9e9df6767e29 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -11295,6 +11295,23 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
> >   	.seq_info	   = &bpf_io_uring_buf_seq_info,
> >   };
> > +BPF_CALL_1(bpf_page_to_pfn, struct page *, page)
> > +{
> > +	/* PTR_TO_BTF_ID can be NULL */
> > +	if (!page)
> > +		return U64_MAX;
> > +	return page_to_pfn(page);
> > +}
> > +
> > +BTF_ID_LIST_SINGLE(btf_page_to_pfn_ids, struct, page)
> > +
> > +const struct bpf_func_proto bpf_page_to_pfn_proto = {
> > +	.func		= bpf_page_to_pfn,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> > +	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
>
> Does this helper need to be gpl_only?
>

Not sure about it, it wraps over a macro.

> > +};
> > +
> >   static int __init io_uring_iter_init(void)
> >   {
> >   	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
> [...]

--
Kartikeya
