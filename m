Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117801AE3EB
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 19:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgDQRmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 13:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730098AbgDQRmf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 13:42:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0074C061A10
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:42:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t4so1212078plq.12
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KjrOit2pYvG6gEqrAeDYI3gE0UdgfpjpULdnfz35SG4=;
        b=hfCzRr7n9mEYTAzBtGsqWPrXejcBdO5Qow4g1jcQych3gq3xMjtal1xwI1r0Xaltxg
         yOtWdQuQor/DxpjYesdIWV0ZJ0OS84Rbas3R5Jo6sGHlqZV8IucD609aVErkzYTaozDW
         iZRPrR2VgmL6QzTT68OtXYFHagWH+Xrq2cJ5T7LGCn65ywk8bJGveZF5ugT8ycyWpad1
         gzB9YmagGJgST/YiEpY5nw9TpSElJVBxpla1je6WnVaA7RC1tTXPHwHEln0rgGic2siW
         kGIgF6hQ1pWO7t16HoW4SP7IVKGatWHYZkn70aDNcWTBQp3kJ1rLWPQRorrfjanJEROC
         ZAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KjrOit2pYvG6gEqrAeDYI3gE0UdgfpjpULdnfz35SG4=;
        b=SAqu9la1Nhbz9wpkj57elPXL6WpyWR+6CHQ6P/ZbM0YEiwof7no0Y5SvWz2CItND9v
         RTjgxN4v1ESdHOTqXNjjmxNEB29JyxOQCayFLKHvtqsSdkbYwPT/oBf37L1Jq9Y2erBw
         ePpoDwvcqNYMa/7gRl/AcbBm+GSUosPQ9Rz5zYy4lkmurXyt1Qs6hACOeGssEfTjOi1x
         MUlguVRbjz3CeoIJS64oHDz3x5xJU+6+ciyarwIDMjiZ0QMGlgs5ucyXhfOXm0yOS9sP
         yOjbWVmlAcmblIHP2fafB7M5lFsjSMhxhx35XOwgZDSzaIrQ9/XUUH58RnCzHvLgqH1k
         gO2A==
X-Gm-Message-State: AGi0PuZkTbWxErEEbciiuP+jwcS+aquQE99K3GvH+c9LUnSxkndQLMzA
        qsLfbyhSTVSZh6jRWegFHsmpyyWGiqBE9g==
X-Google-Smtp-Source: APiQypKVAurQv52m9wQY/0bAGCeuAPfRMLq4iN/ZNr5XO8b0GoTa0DND2q3neyht7vIzBR1tbdREHA==
X-Received: by 2002:a17:90a:364c:: with SMTP id s70mr5685521pjb.143.1587145352627;
        Fri, 17 Apr 2020 10:42:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id h15sm13021131pgj.35.2020.04.17.10.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 10:42:31 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
 <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53ee39ac-2d97-9bcc-80c9-5ed9b0868e8f@kernel.dk>
Date:   Fri, 17 Apr 2020 11:42:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/20 11:26 AM, Linus Torvalds wrote:
> On Fri, Apr 17, 2020 at 8:16 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Work restore poll cancelation fix
> 
> That whole apoll thing is disgusting.
> 
> I cannot convince myself it is right. How do you convince yourself?

req->poll is used for pure poll requests, req->apoll is used for poll
that is armed on behalf of a non-poll request. So the paths are actually
pretty well defined, for both the submission side entry, and the
completion side which is through the wakeup handlers.

The handlers that deal with the "poll on behalf of another request" is
pretty short and limited. Anything that uses "poll on behalf of others"
is not going to be queued async, which is the overlap with io_wq_work
in the io_kiocb structure. The only part we have to be a bit careful
with there is for the assume contexts, like mm etc. One of the fixes
in this pull request deals with that.

-- 
Jens Axboe

