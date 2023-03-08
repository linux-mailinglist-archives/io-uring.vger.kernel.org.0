Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240456AFF19
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 07:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCHGq6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 01:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjCHGqy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 01:46:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA39EA0B27
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 22:46:52 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so1286292pjg.4
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 22:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678258012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kmG46A14t7t7HVqup7DVsAme3iM/60xWBqiw7dTDTPU=;
        b=Ev67Nwmsj4lVyjgef4etBdUJEpcOOJ8D6B32kQDIDeTk2eLKG6OvWi6tKtUmsI9Yjx
         S7agcPVk4yON+V3qFyQumfsRwSJB5gpxxnVYSpHiA+ZjEwkmTIyaAOGu9TeBEhTCDsG6
         UVIAJeG+/qd7LUGUCe7lCxmFtKFiJuohMJ1+sqQ5gyUqzoAuTbylG/NeCa1WkRcdjTp4
         UUq7BU8/4hv7qqYC0RnJdgam3ZbCGVsJaYWFfx2bs9vrLDzb8ZxiTGD1otny7xRLeblK
         oczdR4CdFqyXwDHnzxAk/IGCgurGOv1VjhGjMTHD9mAXZAKigljh1gZe2tquUhVnFONT
         +psQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678258012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmG46A14t7t7HVqup7DVsAme3iM/60xWBqiw7dTDTPU=;
        b=YA9eH8n6tBCr7PCQeOaeXSTjP7lq1Q7bWQzUKiZraWHYr4MNzPvhM/EuqYI/76bzyl
         3YYhLIvUh/lIanwTxq/Pu6GKye8vmnWDaXvFNUzZSaojOXbHhdlVFELGxeJA9U/d7jZ3
         6KjRP/19+kNOWWw0u1NgQog0ns/rKBTDt76RADd3bBbH0pUQ+uz1GjP1ok0ETgTZ7+jU
         tJSKVCG6nIb2yhUGlzI9+w/js9aBZ54Uy5/Z4EXL/UcpjvlAbD3JO0J9c0evFkX8jlV3
         RZUWLokNLRSr9VPWkXgosGVjca250fOZ9xvXlgTadAm+LT2RZYV4hIg9WOr2/5O0Jemg
         ffzQ==
X-Gm-Message-State: AO0yUKWVl2Qvki4chx6qzLIqWZGsjXa0JgnYqsw8nQP5B8CfFUpd/OA4
        Bh1GkbjhifaVeuGxqH5h+IQ5GQ==
X-Google-Smtp-Source: AK7set+jfx6/JoFPDz1KR4qP1hDTo3hq+3N6Qi6/fEevr/4FR1O1umr8spU4VNLsHVuScbBHjZiMmQ==
X-Received: by 2002:a05:6a20:6f57:b0:cc:b662:9e7c with SMTP id gu23-20020a056a206f5700b000ccb6629e7cmr13992368pzb.46.1678258012166;
        Tue, 07 Mar 2023 22:46:52 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id w18-20020a63af12000000b004fbdfdffa40sm8606537pge.87.2023.03.07.22.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 22:46:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pZnZY-006C1p-P7; Wed, 08 Mar 2023 17:46:48 +1100
Date:   Wed, 8 Mar 2023 17:46:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET for-next 0/3] Add FMODE_NOWAIT support to pipes
Message-ID: <20230308064648.GT2825702@dread.disaster.area>
References: <20230308031033.155717-1-axboe@kernel.dk>
 <30edf51c-792e-05b9-9045-2feab70ec427@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30edf51c-792e-05b9-9045-2feab70ec427@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 08:33:24PM -0700, Jens Axboe wrote:
> On 3/7/23 8:10?PM, Jens Axboe wrote:
> > Curious on how big of a difference this makes, I wrote a small benchmark
> > that simply opens 128 pipes and then does 256 rounds of reading and
> > writing to them. This was run 10 times, discarding the first run as it's
> > always a bit slower. Before the patch:
> > 
> > Avg:	262.52 msec
> > Stdev:	  2.12 msec
> > Min:	261.07 msec
> > Max	267.91 msec
> > 
> > and after the patch:
> > 
> > Avg:	24.14 msec
> > Stdev:	 9.61 msec
> > Min:	17.84 msec
> > Max:	43.75 msec
> > 
> > or about a 10x improvement in performance (and efficiency).
> 
> The above test was for a pipe being empty when the read is issued, if
> the test is changed to have data when, then it looks even better:
> 
> Before:
> 
> Avg:	249.24 msec
> Stdev:	  0.20 msec
> Min:	248.96 msec
> Max:	249.53 msec
> 
> After:
> 
> Avg:	 10.86 msec
> Stdev:	  0.91 msec
> Min:	 10.02 msec
> Max:	 12.67 msec
> 
> or about a 23x improvement.

Nice!

Code looks OK, maybe consider s/nonblock/nowait/, but I'm not a pipe
expert so I'll leave nitty gritty details to Al, et al.

Acked-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
