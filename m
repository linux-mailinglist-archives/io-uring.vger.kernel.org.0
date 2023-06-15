Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3850730D2A
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 04:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjFOCXA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 22:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjFOCW7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 22:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE81FCC
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 19:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686795732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBhgNckHvS740wOFzsaqmG24H1PbdTDM9ZPi52SJjds=;
        b=gylnAs0+DYL/rB9jScmdezTow6fCkCf6uS/80gIxbv1fsz5RnTqH0GCquHIQVAJKr77NJJ
        znXPtoAnTjoIiNjt79sR5foj04MP//xObKdsY/LErsujrJvCUU3u9wmdJ2dlx8oXpj7wmG
        PeHrUID58XrZX2wJUBF/BK6NuvpsH/s=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-AlbVTzc5MGGvBGklbefiwA-1; Wed, 14 Jun 2023 22:22:10 -0400
X-MC-Unique: AlbVTzc5MGGvBGklbefiwA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-65a971d7337so197753b3a.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 19:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686795729; x=1689387729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sBhgNckHvS740wOFzsaqmG24H1PbdTDM9ZPi52SJjds=;
        b=giBzOKvICeFIMk8BNZ2h9efAzlrbr00mkRUMEiuyTht4cT82C/Y+YbHpfSjELqLzTS
         Q4m4FNbb3bhht7UcYCYr/6KCqMbOJygVg5hnSdBs+dSB7R7bJd8+TzfII0WCLVwng2Hf
         shwbVqNIEXCJdu3zmLn3azdd3QPfK8+wGICz2ElsSgfzcnobbpC5pmdpHPEcTLKHwlgJ
         HyuKt5WTgAMW0cJQm4uWk3EVjcOxl0Xwjb4jRKExKQXuQanqExyTLbb7Hc+8rAvv6SEH
         PyyYqAxD3DJrnVsGdl4CxhOaNjcqMOMX1hjh1R5CT93C/rhGCyIilJEANVpmgQDeHADH
         NyYw==
X-Gm-Message-State: AC+VfDwLqj4IpXBOiOxibl8RsZZiGfvNMNKVJTOOwPljDD9qcQzsCGzC
        We0mnbkiUk4bQetrlb7KUKOAKxKrrGcu1ihCTFwahIZIxno7Xa1twELh03YXYKwgJGkqopwMqDG
        Sx13Aq+Xq7j9ApsOJkrw=
X-Received: by 2002:a05:6a00:17a7:b0:666:41bd:5088 with SMTP id s39-20020a056a0017a700b0066641bd5088mr5193169pfg.13.1686795729463;
        Wed, 14 Jun 2023 19:22:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7SxzBGCpn0ipxbfWT663RUSjvniqGMSITvv0NSpxNr0xNkYJqKkMhgj+cAYUJ4dj2mO2b9mw==
X-Received: by 2002:a05:6a00:17a7:b0:666:41bd:5088 with SMTP id s39-20020a056a0017a700b0066641bd5088mr5193150pfg.13.1686795729115;
        Wed, 14 Jun 2023 19:22:09 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p3-20020a62ab03000000b00646e7d2b5a7sm326075pff.112.2023.06.14.19.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 19:22:08 -0700 (PDT)
Date:   Thu, 15 Jun 2023 10:22:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
Message-ID: <20230615022203.3nh7qefrbhzboz43@zlang-mailbox>
References: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
 <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox>
 <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 13, 2023 at 07:14:25PM -0600, Jens Axboe wrote:
> On 6/13/23 6:54?PM, Zorro Lang wrote:
> > On Mon, Jun 12, 2023 at 12:11:57PM -0600, Jens Axboe wrote:
> >> A recent commit gated the core dumping task exit logic on current->flags
> >> remaining consistent in terms of PF_{IO,USER}_WORKER at task exit time.
> >> This exposed a problem with the io-wq handling of that, which explicitly
> >> clears PF_IO_WORKER before calling do_exit().
> >>
> >> The reasons for this manual clear of PF_IO_WORKER is historical, where
> >> io-wq used to potentially trigger a sleep on exit. As the io-wq thread
> >> is exiting, it should not participate any further accounting. But these
> >> days we don't need to rely on current->flags anymore, so we can safely
> >> remove the PF_IO_WORKER clearing.
> >>
> >> Reported-by: Zorro Lang <zlang@redhat.com>
> >> Reported-by: Dave Chinner <david@fromorbit.com>
> >> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> Link: https://lore.kernel.org/all/ZIZSPyzReZkGBEFy@dread.disaster.area/
> >> Fixes: f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> ---
> > 
> > Hi,
> > 
> > This patch fix the issue I reported. The bug can be reproduced on v6.4-rc6,
> > then test passed on v6.4-rc6 with this patch.
> > 
> > But I found another KASAN bug [1] on aarch64 machine, by running generic/388.
> > I hit that 3 times. And hit a panic [2] (once after that kasan bug) on a x86_64
> > with pmem device (mount with dax=never), by running geneirc/388 too.
> 
> Can you try with this? I suspect the preempt dance isn't really
> necessary, but I can't quite convince myself that it isn't. In any case,
> I think this should fix it and this was exactly what I was worried about
> but apparently not able to easily trigger or prove...
> 
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index fe38eb0cbc82..878ec3feeba9 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -220,7 +220,9 @@ static void io_worker_exit(struct io_worker *worker)
>  	list_del_rcu(&worker->all_list);
>  	raw_spin_unlock(&wq->lock);
>  	io_wq_dec_running(worker);
> -	worker->flags = 0;
> +	preempt_disable();
> +	current->worker_private = NULL;
> +	preempt_enable();

Hi,

This version looks better to me, generic/051 and generic/388 all test passed,
no panic or hang. More fstests regression tests didn't find critical issues.
(Just another ppc64le issue, looks like not related with this patch)

But I saw fd37b884003c ("io_uring/io-wq: don't clear PF_IO_WORKER on exit") has
been merged, so this might has to be another regression fix.

Thanks,
Zorro

>  
>  	kfree_rcu(worker, rcu);
>  	io_worker_ref_put(wq);
> 
> -- 
> Jens Axboe
> 

