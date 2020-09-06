Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F525EF1A
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgIFQ0B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 12:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgIFQZx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 12:25:53 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC10C061573
        for <io-uring@vger.kernel.org>; Sun,  6 Sep 2020 09:25:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o20so7315112pfp.11
        for <io-uring@vger.kernel.org>; Sun, 06 Sep 2020 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vblChfoe/5kxvkqA7a1E3pQDxsnKHIsnz/PFgAgkjlg=;
        b=lAkgHsmLLkVHMjlyqIsdiJfxNkpA3bdjo7NcikrwMifrI1SsU5wo0N44cMAEtX1Zw2
         zJTE8H9oXXm9q55wt+tWet2373OscFGX7S67h6OhQ8JXAXA6ZTOGnIs+53sn9GEB5Xoz
         yCAOz79m103HOja3szHjeYF4B4x/EV+YgKSWBD7CP1Ae2EDvPOCsXE0CWtKPUaUWCkf7
         hJaBX6AHJXHvr/0feg0AuIa0s/HHlKgHdLYjnOI4Z7Qf31sDWQAiCgrRMhg2+leB4zoJ
         DSWxpdT/AfNU2QX780Z861ibRqeo6+BVGivF9NDUE3UTiyfhNDWxvTeDa+oUqJLHR4jW
         XfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vblChfoe/5kxvkqA7a1E3pQDxsnKHIsnz/PFgAgkjlg=;
        b=SNGwXZNmLfzpam3kzHAqHZYB5RXtaN8/uZz6oiW836nbDrSsUS+d27PVrVi0l/quHr
         6YCFPVGuL4vmiWjl96RFESxyP54PWXl6Qk/iiwEYPObGxytWY+uzAzoPXarvDxmraQlv
         Weo4FtMWr9xe0FHsZnFslfLM5SjpUoBryu08ZpsPQxGsexycAYOSakDWBXkRQWxGen9j
         vjaIxNywcm3TPzvep9M/aKrIzxnfKAvzw366zudRJOAlZ4wPsWSXPrFjM30YVUpCHPLn
         5ZBteI0n+MsDKYxw61DdyG0WpltjPXY0xZDnlS6bI0Pjq4l2A367DKzQC2TcvQ2KJW/T
         xgKQ==
X-Gm-Message-State: AOAM531Yw0nki0A6cPORM16HV0M8VdiNv/fvO7KdQCqiO9Qs0cn0ShB1
        g7O3ShEoD5MOeCk3baWTJ2oLXsBeqr9XREti
X-Google-Smtp-Source: ABdhPJwjQbp4tgitXO547BRPgIpppo19yM1wuklduQEPaV47GbbuuLHf89Tv89o6QIpl0fvaAQzEwA==
X-Received: by 2002:a63:5c1a:: with SMTP id q26mr14380720pgb.223.1599409550907;
        Sun, 06 Sep 2020 09:25:50 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a10sm12363701pfn.219.2020.09.06.09.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 09:25:50 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
Date:   Sun, 6 Sep 2020 10:25:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/20 10:24 AM, Josef wrote:
>> You're using the 'fd' as the file descriptor, for registered files
>> you want to use the index instead. Since it's the only fd you
>> registered, the index would be 0 and that's what you should use.
> 
> oh..yeah it works, thanks :)

Great!

>> It's worth mentioning that for 5.10 and on, SQPOLL will no longer
>> require registered files.
> 
> that's awesome, it would be really handy as I just implemented a kind
> of workaround in netty :)

On top of that, capabilities will also be reduced from root to
CAP_SYS_NICE instead, and sharing across rings for the SQPOLL thread
will be supported. So it'll be a lot more useful/flexible in general.

-- 
Jens Axboe

