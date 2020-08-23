Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FADC24EF0F
	for <lists+io-uring@lfdr.de>; Sun, 23 Aug 2020 19:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHWRjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Aug 2020 13:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgHWRjb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Aug 2020 13:39:31 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6CFC061574
        for <io-uring@vger.kernel.org>; Sun, 23 Aug 2020 10:39:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so3427798pgb.4
        for <io-uring@vger.kernel.org>; Sun, 23 Aug 2020 10:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mY96LIkN1h9fUPTsChLJqQ4p1857Mmj7eT3GfCFBt0g=;
        b=MvQeZqU/w0RFMTCRx0FxIpQXO/zA+XNIHtyvjxmJRPH3BOpcpHjoG1gP5Kta+Hp1Zu
         VYACb6bgUApYQVn2NfTvfjzM/0ig/gOL0lfYKwpMNnmaIgOMaBUUvUvly1zNBYhQiSlQ
         FYKMF8Suxm2h4FBJG4RGPQquflKuOanTTg6P1zmScXQc/f6pINUh40zkxGZWXZ3QnjVZ
         OL0pagb1lGjoQa0uYoqwt/fhLS4Vim65KqwOcQrNdM6u0j8Yr3nezY3x/6CpNxjfJiy0
         /YbFGiiAwfd9UzCDaIRa5JI0VQ9HMB92Jys0SHPlpK9eSBUAOuG3ly63DJDGnSA3O4mz
         iA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mY96LIkN1h9fUPTsChLJqQ4p1857Mmj7eT3GfCFBt0g=;
        b=BhVKKmCm4s8s2qCJxm2iGSaSWsJnFcxr2vnWsJQ0R7Bzb/SkbvjZ6on7krYAVLa5oV
         L8uUcWBlYwzON8SQujgZiGwWg7ykMJQHSW+1tTjGyEgemELYlDMdaxP/N7wTBXyzAF2Z
         0oSvyVYSpNGcA3egtCn50Fk0uUcXBwMpkKIRszPudDpF2WVxmh+uOW6gMVc9a+sSH1Hb
         rdjHVMmsiyjnFkU72o2kpC7I1bG62bRShkChTVG6g9LghfXH0o4lFFa7B9AAEF6xBjPK
         sN9yN6Kiw8H3e0P6K733qliZ/QPe6df699nwUxL5dg7gK//SrykiaxdOq2SGv2o2F/v6
         ceSw==
X-Gm-Message-State: AOAM531UOMzJInRr0g9hTpFOcKdR/AemnQFYYCEmQVYXfJnj8PxltL9r
        R0Qr68YQVX89c1yhYMQzEz6d8Q==
X-Google-Smtp-Source: ABdhPJxwJAmu+XSPeKf7LDKpimGHmBL7tinYSBo63P3vJDPbu5NlkgL4gcoUMVVAayI+sxKkvZcEUw==
X-Received: by 2002:a62:7d0b:: with SMTP id y11mr1399116pfc.262.1598204370006;
        Sun, 23 Aug 2020 10:39:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y4sm8833195pff.44.2020.08.23.10.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 10:39:29 -0700 (PDT)
Subject: Re: [PATCH] io-wq: fix hang after cancelling pending work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Dmitry Shulyak <yashulyak@gmail.com>
References: <c62b225cc7019d0a8ef686d0f87dd1612d9768ab.1598203901.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05a99d44-8310-c8b1-b863-5333c94347f4@kernel.dk>
Date:   Sun, 23 Aug 2020 11:39:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c62b225cc7019d0a8ef686d0f87dd1612d9768ab.1598203901.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/20 11:33 AM, Pavel Begunkov wrote:
> Don't forget to update wqe->hash_tail after cancelling a pending work.

Yep that fixes it, figured it was something related to hash work
cancelations. Applied!

-- 
Jens Axboe

