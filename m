Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ABF6BB76A
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjCOPS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 11:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjCOPSZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 11:18:25 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926EAA26D
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 08:18:24 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id y12so6308259ilq.4
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678893504;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u7XncQ9/sIoMiOOEGX+PprU8+JUGDG7Lt2ET/LQl0Nc=;
        b=tcmygfkVvHJ9SzrtivAdapon0DVzVM/QCeSQx/MbeOyUH4g/3NmEvo08z7g9H+BGO+
         z8AL+mx35ogsrpMySGJB8VfCySQrg/8YAC6tGBCK/OGpMDG6CA5f664AxIMb5mF1QUCq
         11HbBfP4DpNZ40O5DOVCpkJXLQkDu7WOcDRDs4fDKJFFKwRx3EYzq83x07R1yASHnIiO
         XppWmAI/6zg+RS91NwUPuwLkn9kTEf5gLvYOH/lclAlNqO7H/ikszQzp7kBT4M3Z2OW/
         Vf00FhTxx4yEPJxekUkE+SkJyz2enN/bEMtV0EiTEVYhplOy84ycrlikJXPOEmH5tM1K
         E6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893504;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7XncQ9/sIoMiOOEGX+PprU8+JUGDG7Lt2ET/LQl0Nc=;
        b=GGlRkju7tbj94SCaUTgXDR1PD7oMuT1u42dCUBIC9Rcw/68qkG+8aCmAGRY3z4vrK2
         YdDzIq8/WYfa0ZUuaGpV7zApX3vPOS1kryFJ/XIEc5XF7srPMvfTGv3TTP7h8ce3Zy3o
         eIId6iYkTPNR17dXEIx3uRG5/CL51wtr6dDxIKkZePEOMEbnP657dKFVD0hIG/YCqIrU
         LHdIpGnnHO/JHZiwxfhS979N26DTlLhCfeO9D91FefS0ZfpvjSNklPFZQ76XpL8Hh2Bk
         LxZxkcYQmcik0hE2j2vgeNL1Q4sBgIn8Hamm+5vX8AsEzd1yLAOHGl+0+EE700DhbaMl
         8vLw==
X-Gm-Message-State: AO0yUKWGRri4tYSFBohDmSDbP56lotxkmgghgs8TaqrSmLEdIq5/4K9c
        eq1ttdHIwYSNHMysja8H+mw2sQ==
X-Google-Smtp-Source: AK7set9sFpTEy2f6zuAyOXjezk2McNh3h8eU9r3sPCx5IIkRdcvFUC0d7JW9a6tM/A9ROfdHA6VxQA==
X-Received: by 2002:a92:874a:0:b0:317:9d16:e6c7 with SMTP id d10-20020a92874a000000b003179d16e6c7mr10952501ilm.3.1678893503878;
        Wed, 15 Mar 2023 08:18:23 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u11-20020a02cb8b000000b004061ba59f18sm475427jap.120.2023.03.15.08.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:18:23 -0700 (PDT)
Message-ID: <a9ccda55-418b-4a32-616e-82893d2eacc1@kernel.dk>
Date:   Wed, 15 Mar 2023 09:18:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Resizing io_uring SQ/CQ?
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora> <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
 <20230310165628.GA491749@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230310165628.GA491749@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/23 9:56 AM, Stefan Hajnoczi wrote:
> On Fri, Mar 10, 2023 at 11:14:04PM +0800, Ming Lei wrote:
> 
> Hi Ming,
> Another question about this:
> 
> Does the io worker thread pool have limits so that eventually work
> queues up and new work is not able to execute until in-flight work
> completes?

It's effectively limited by how many processes you are allowed to
create. If you exceed that limit, then yes you would have work
sitting behind other work, and that new work won't get to run
before _something_ completes.

But no ring sizing will save that, you've effectively exhausted
any resources in the system, at least for you.

-- 
Jens Axboe


