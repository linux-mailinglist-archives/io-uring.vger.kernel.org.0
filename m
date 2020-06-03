Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293F51EC710
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 04:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgFCCHR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 22:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgFCCHQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 22:07:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0323C08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 19:07:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id h185so517121pfg.2
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 19:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=05oZ75W4PAkbEc2W7bJ8bzylCGe8tKmwbPUEdrxK2MI=;
        b=YgjDG2DOa5fJsziE47TJOIqO8/01xtN5rj6XQhEyI58geqkjsw62uCrQ7ZmmhL1jkL
         +kdgjXt7D4Aq84xaZGh0L81EUocGLPlyFYiHF2fvO1P9QWVrCSVyYbDEz9iL9hZEe4Ui
         7YZAAfcJIdO1plU1NAB8hK7wr7/4flAHjNYD8hU0lNN7/8+Zkt4blJX442q/S/nA/vZh
         ugEK+rcs2zZVVsFqei43wS/VJn57yAxbDa+HeKXRww6Cp4IUKjMn6uAQPi2N6jZB0j3A
         bduC0KNOtfAW6NAb8ORPkEUhbnT2iM3J6BRWL+y5fs4WuBDMiQzfut9IcvNApvAQ/5b+
         ACDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=05oZ75W4PAkbEc2W7bJ8bzylCGe8tKmwbPUEdrxK2MI=;
        b=LVY0EvzZQOjnfw8YHaclCz/BNDBmLbHnyqpJ1Yzxamc5pExx/c1Cr1iJFphQ0LHpti
         IpfzCq+HlYRzwTdk8bz5xbM1BT1kAbgR/0B2h/HvmCfTyXVwv2/gcYSfgbXQcURLZoRV
         tWm8nkbu2lAbCre4RAIizdyIIzi6GRpY/W0ukWS0hBI7dKUbgIPXOnzZ5HmutLWOLn8F
         RUhabdXzJmEAYvl+eZHBHg+yOHPuq38dNBgIOkt3szjW7nMpXOsIxPGc8sCagsoqPjx6
         1VdWTrFffAbNFeVPxC8JR4EkbYzw2zcNSSbBBKulN4htTSq+BK25EbS3OCTFHFVlUXfO
         AoXg==
X-Gm-Message-State: AOAM530uRifmk8jAfp5MwIzbZ2fzrtMlmgVhdEKoCWetURbkO/zOJ0bD
        x60fvkhePXs3Falc4UpV2vNKyw==
X-Google-Smtp-Source: ABdhPJw+m9Bk6S9FVc4FjMyeOU0mdWCwQ/Z6Zb3KXA32gR56BP6UBcW9Kd3MbvhePimU1xOaEgMogA==
X-Received: by 2002:a17:90a:d998:: with SMTP id d24mr2559305pjv.33.1591150036093;
        Tue, 02 Jun 2020 19:07:16 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k7sm216841pga.87.2020.06.02.19.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 19:07:14 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.8-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <dacd50ff-f674-956b-18cd-9d30e2221b09@kernel.dk>
 <CAHk-=wjuAN_vgUN_TiPtzSpz2NX9XQq7-nJ1u=gHG=EKdRdrkA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <237d782f-8163-dbc2-4505-ed5f88ce4362@kernel.dk>
Date:   Tue, 2 Jun 2020 20:07:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjuAN_vgUN_TiPtzSpz2NX9XQq7-nJ1u=gHG=EKdRdrkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/20 5:03 PM, Linus Torvalds wrote:
> On Mon, Jun 1, 2020 at 10:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>   git://git.kernel.dk/linux-block.git for-5.8/io_uring-2020-06-01
> 
> I'm not sure why pr-tracker-bot didn't like your io_uring pull request.
> 
> It replied to your two other pull requests, but not to this one. I'm
> not seeing any hugely fundamental differences between this and the two
> others..

Pretty sure that happened last time too, but I don't know why. For
the incremental ones after the merge window, it seemed to work fine...

-- 
Jens Axboe

