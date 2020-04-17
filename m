Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5941AE285
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 18:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDQQwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 12:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgDQQwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 12:52:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DBFC061A0C
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 09:52:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o1so1317767pjs.4
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vWuhBwjYLA6af0ATp4czW21HWr+A1Pnv85JDCmtLUmc=;
        b=HC6FEBnXobSQQnc3okSkG8k4pfyHcmlWiCC3zKjykzUk0YE47gr/8D1GGX++brL716
         RRwmu9+FfLYRWrMowlD5pekiwOtlLiUcAKlewu73RpCYMw78BzsinUBx0H6zJgWZuPqm
         P9KcQKp6otsJEhQI6wk1ftDGDDKZzpUc6FzKI2JmPliBHsOhD5Li4AnzdVw7XH0XFgiO
         JH/yR9JAJNycnWCSObLl6BuQLuSWOF78uN+ebJpUcug3WuaWR/R+MLMnVkJMbfoYa+nR
         rukRngBvOPcgNxxWVTPxMY/Obg3UYqWq3h1uwvJlUAG/LI96C99o71CItoPJCOMDXoeO
         LTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vWuhBwjYLA6af0ATp4czW21HWr+A1Pnv85JDCmtLUmc=;
        b=h5MIMqH2uh6mbPKOpXrDxKPE2Dns4Xch4NElcPcZBfCbKrnYYKzs3wJfFOX/PMtEAJ
         mkDnSAoVGgE4M8ti2Mu+qclHSPydfeN31tYv7hC18Dm0dh8E5iTL5/FPmzkxPZwJ3Y+h
         HhBnZlvMl39TpK6zwQH98jbKhSnh9yb5E4kLdWowqNc+ITZrTfhSjyqZqhN4p7wT8Yvl
         pBc+f58TP3BUbSUTRnw0j9uSE3TXz+CHNk/83Mu1MqsPsnWdm5t08Tql2LxSHheAb4gS
         2uRGdiUp6xE7cAHtm/T/RRcJQTqvC29Bto3x9zNGF4h9czHmXFswcXkbjDN8l7AhiI3d
         xQYQ==
X-Gm-Message-State: AGi0PuYiLM7G9bihZauuc+GmM9CA3QMx1A5XXzwBilvZkgxnEPBnjXoW
        09jA8dkv09N3XXeQ9WRG0GffiFGIoI9AHA==
X-Google-Smtp-Source: APiQypI4NI2G8luSYCnbKBeng/67cM9aVWfgssTa8GsQkkBy9iNhkhamcRkMfklLhMkCZEnNkkjBWQ==
X-Received: by 2002:a17:902:fe09:: with SMTP id g9mr3805498plj.171.1587142368238;
        Fri, 17 Apr 2020 09:52:48 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 1sm6128371pjc.32.2020.04.17.09.52.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 09:52:47 -0700 (PDT)
Subject: Re: Upcoming liburing-0.6 release
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <2ec49990-639a-f6ac-15ca-7ac26d2d9769@kernel.dk>
Message-ID: <ed9165c6-98ba-bbd9-e046-6d96c7cbafca@kernel.dk>
Date:   Fri, 17 Apr 2020 10:52:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2ec49990-639a-f6ac-15ca-7ac26d2d9769@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/20 9:28 AM, Jens Axboe wrote:
> Hi,
> 
> I want to release 0.6 this week. Just a heads up if you've been holding
> back on a patch or two, so the release doesn't catch anyone by surprise.

It has now been released, shortlog here:

https://brick.kernel.dk/snaps/liburing-0.6.shortlog.txt

-- 
Jens Axboe

