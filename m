Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954944407DC
	for <lists+io-uring@lfdr.de>; Sat, 30 Oct 2021 09:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhJ3Hd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Oct 2021 03:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJ3Hd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Oct 2021 03:33:26 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FEEC061570;
        Sat, 30 Oct 2021 00:30:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so46003896edj.1;
        Sat, 30 Oct 2021 00:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AXA9li2tKaCAh14FXsDbXXTUi0RI8sNogEieGoLqb+8=;
        b=axr/sf5j7zbTlZhUbEMOp9lAm1nB2D0HIl6wzTTyU+7SsS9bxLRtjW4oZBD9gW0XYv
         Y65WLMNBBIwUKiFQomMSP2pSP3giubrA8etRSD6Lwko7VtkxyLJ0j/2EMSQWQTQcpQjk
         FE8+JWvz+7wvgOVxKAYKxV8c47GLbnGP78rHq8Mk4CGviniy+iIs+JzGOCnWwYjwaGNe
         atkPMuaYjRlIB3HM/98oH0fznUrjZpBpJZWxneykzhoG8JT2XEUjqIEbBMkuLjIYmu5o
         h18JAyFDXlqJEsbJj3ZK5HRuXWduTB1hTXcVucARreA18vWWCdTghKD8AQzGz7WLZdaL
         tBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AXA9li2tKaCAh14FXsDbXXTUi0RI8sNogEieGoLqb+8=;
        b=VhtYVUEAGPqZVX5ZK+Hh2ZeOGRQHqfodltszy1BOcseRH+lXrAGi8NZdSh6+nX8D/A
         3Owa2wdXudj9IOuff3UitTe+KQlfDoefzGD+87uuZaT+DAxRzmuprZI94npFFGfnWJZG
         H1BmZUtHW5I5ax5sA/YOFa7RA1RTRzRvWHsHHVNU5sHpreJWUv+NBQ+aqN+KQvpM2rPX
         PZPpuOnTHIxU95fxcRC1HIWzixUNPUg8BExMjgEa3yhNh1y2znWGS+rj3OQ4mbSgj1Jb
         aSq5V8aQ8aLySvzAFbhILtoJIKckZXBEVFA7xpy1oU3w2UTTauaxLqSzjRJfe7xcGWXR
         UMgw==
X-Gm-Message-State: AOAM532y8guqHJtmOhc71SYdTGnYVM7PNkJ3YrwpE5gg2OoT3tg4cryZ
        HeSEG0NmRDsA8ThCkRIiGvp5gKPohnirqg==
X-Google-Smtp-Source: ABdhPJzTOTbbnH5GhbmXasFImzXRKTkVVGI9UfKfoznVSt4xMwp11bnR08bhkGYUjrg6/hMkKPg02g==
X-Received: by 2002:a05:6402:42c8:: with SMTP id i8mr22479340edc.349.1635579055253;
        Sat, 30 Oct 2021 00:30:55 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id f22sm4827173edu.26.2021.10.30.00.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 00:30:54 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 30 Oct 2021 09:30:54 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Daniel Black <daniel@mariadb.org>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: uring regression - lost write request
Message-ID: <YXz0roPH+stjFygk@eldamar.lan>
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Daniel,

On Mon, Oct 25, 2021 at 12:25:01PM +0100, Pavel Begunkov wrote:
> On 10/25/21 12:09, Daniel Black wrote:
> > On Mon, Oct 25, 2021 at 8:59 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > 
> > > On 10/22/21 10:10, Pavel Begunkov wrote:
> > > > On 10/22/21 04:12, Daniel Black wrote:
> > > > > Sometime after 5.11 and is fixed in 5.15-rcX (rc6 extensively tested
> > > > > over last few days) is a kernel regression we are tracing in
> > > > > https://jira.mariadb.org/browse/MDEV-26674 and
> > > > > https://jira.mariadb.org/browse/MDEV-26555
> > > > > 5.10 and early across many distros and hardware appear not to have a problem.
> > > > > 
> > > > > I'd appreciate some help identifying a 5.14 linux stable patch
> > > > > suitable as I observe the fault in mainline 5.14.14 (built
> > > > 
> > > > Cc: io-uring@vger.kernel.org
> > > > 
> > > > Let me try to remember anything relevant from 5.15,
> > > > Thanks for letting know
> > > 
> > > Daniel, following the links I found this:
> > > 
> > > "From: Daniel Black <daniel@mariadb.org>
> > > ...
> > > The good news is I've validated that the linux mainline 5.14.14 build
> > > from https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/ has
> > > actually fixed this problem."
> > > 
> > > To be clear, is the mainline 5.14 kernel affected with the issue?
> > > Or does the problem exists only in debian/etc. kernel trees?
> > 
> > Thanks Pavel for looking.
> > 
> > I'm retesting https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/
> > in earnest. I did get some assertions, but they may have been
> > unrelated. The testing continues...
> 
> Thanks for the work on pinpointing it. I'll wait for your conclusion
> then, it'll give us an idea what we should look for.

Were you able to pinpoint the issue?

Regards,
Salvatore
