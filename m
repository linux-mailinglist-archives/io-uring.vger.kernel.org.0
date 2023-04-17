Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56A46E49C7
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjDQNTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 09:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjDQNTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 09:19:39 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666A086A1;
        Mon, 17 Apr 2023 06:19:20 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-2f87c5b4635so1326379f8f.1;
        Mon, 17 Apr 2023 06:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681737559; x=1684329559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0QEqpLwnwFp5A1m8MrYucaOFzzcBM5ajIcjIAg9pASw=;
        b=GgzfatfZDsG6l1hdBeNLHTz6BCXR5NlEbHsgO0Pdeh5LJ9zwjx2YgPElU6cZSTOAYE
         R/dFJWNOgOc+Uyn4IHLHBATe0U90XZiBoxaQnLl8FKdfwpv+DtmotoQ9ZbpCPks24cPb
         oybhbD+uyhlAte9GX94erRNqO7mJ7/vVVqA9lXphz1Q1zgrA5liTj83juYguLWarwfmT
         Ns5Eu31CjKmX1aTnglR9IfZHZ3EzMS54FdTIzRSMi5AMWhDFqJWmS5j9Yp/xj/rkn0v3
         jjg4p60PThtAYL2s6953ryUNK3WqfCyEZkRPU2ZzDwJks2xWvh8xE4jcZmkjZXUtrBgf
         lDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681737559; x=1684329559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QEqpLwnwFp5A1m8MrYucaOFzzcBM5ajIcjIAg9pASw=;
        b=C0tGmjKouC3eZjc4cBA9nRm9RxrLSi7raWp/RwAtnJ5DASI2s93zdxNPEpG4K25IFC
         VRw/u2S7xlnbCsEnaMa9BuY9miRZb+IFPy5DaMxd7HaBocOGuOwFyp3aweu0dxJRU9Up
         Jv/zYn+w0b7aWNoSap6dF6oTrk3VtDiQiHNAKkaVaQ+2j8j5tFBtPrd3fxH6ffg3J1hh
         nyDq1pmLAbsX7YmGenM2HQiBOysY96212fjYd2Vdbk8rz5fM4oEUozzFGmrTytysO24u
         yyeFAXzJ1u9UwzkXiIztt8CXvZlWFr/kGeWKjBC8Rci0sDPDoJTuyyOmVmyIWyIRCov3
         ydpA==
X-Gm-Message-State: AAQBX9fqwlSwjTwLiEUkLitw3VxDr3rnWEQkptE97qRlSFbeV7STpJh+
        2WUlq34Y8cARPVzSHEuJricU4ZsD1zXzag==
X-Google-Smtp-Source: AKy350ZDipeS7QkU/VGnF7/BCdcymXldDYSzQ/bsTJ8FlmgcHx38mRLO7y2HMs/RxoBdi+rLV1MYrA==
X-Received: by 2002:adf:f40e:0:b0:2f4:cf53:c961 with SMTP id g14-20020adff40e000000b002f4cf53c961mr5062546wro.54.1681737558569;
        Mon, 17 Apr 2023 06:19:18 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d58c5000000b002f47ae62fe0sm10547708wrf.115.2023.04.17.06.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 06:19:17 -0700 (PDT)
Date:   Mon, 17 Apr 2023 14:19:16 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1CAvXee5E5456e@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 09:56:34AM -0300, Jason Gunthorpe wrote:
> On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
> > Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
> > prevents io_pin_pages() from pinning pages spanning multiple VMAs with
> > permitted characteristics (anon/huge), requiring that all VMAs share the
> > same vm_file.
>
> That commmit doesn't really explain why io_uring is doing such a weird
> thing.
>
> What exactly is the problem with mixing struct pages from different
> files and why of all the GUP users does only io_uring need to care
> about this?
>
> If there is no justification then lets revert that commit instead.
>
> >  		/* don't support file backed memory */
> > -		for (i = 0; i < nr_pages; i++) {
> > -			if (vmas[i]->vm_file != file) {
> > -				ret = -EINVAL;
> > -				break;
> > -			}
> > -			if (!file)
> > -				continue;
> > -			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
> > -				ret = -EOPNOTSUPP;
> > -				break;
> > -			}
> > -		}
> > +		file = vma->vm_file;
> > +		if (file && !vma_is_shmem(vma) && !is_file_hugepages(file))
> > +			ret = -EOPNOTSUPP;
> > +
>
> Also, why is it doing this?
>
> All GUP users don't work entirely right for any fops implementation
> that assumes write protect is unconditionally possible. eg most
> filesystems.
>
> We've been ignoring blocking it because it is an ABI break and it does
> sort of work in some cases.
>

I will leave this to Jens and Pavel to revert on!

> I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> io_uring open coding this kind of stuff.
>

How would the semantics of this work? What is broken? It is a little
frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
FOLL_ANON_OR_HUGETLB was another consideration...

> Jason
