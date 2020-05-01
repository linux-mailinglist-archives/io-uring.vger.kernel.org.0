Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261F61C18E7
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 17:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgEAPFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 11:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728839AbgEAPFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 11:05:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B77FC061A0C
        for <io-uring@vger.kernel.org>; Fri,  1 May 2020 08:05:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d7so232430ioq.5
        for <io-uring@vger.kernel.org>; Fri, 01 May 2020 08:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OywnYsOX9HSwp3HTdJRlErOVC37z2JBjZDdUK+Itl5s=;
        b=XoXKYZklpDZih+9yxf0ODOQ/y0+Vmxko1JosGAeZXU45gZMn6YNFWNUWCp9GuaNntH
         O7H5d5gaqvWtU8h0jphO0HZcqqolrQAbHqvWbezjVKK5+M8BF0kxwHFYYSbU86ZbYUKT
         meDetoUN6obcwwZp7R5gR4ZU0dBT+ZBlI6YhoTDNSwjlvWrUSTC1Xuelb2HLtGpyDoMC
         RnmB8M/kQ+XNb0UyKvOQl6BbTj667ABkx5+Uvs2tPgzCP9146Jun+CltJGNQUouL+woA
         xZV6R0wPt4RRMUaJC9bYDt8zAr6jnF//yUv8hXhz2L45SdSeIY1P9SYEVkNgbQgrMMd+
         q/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OywnYsOX9HSwp3HTdJRlErOVC37z2JBjZDdUK+Itl5s=;
        b=kG6Mv1sAuKf0pajypdk4KZhGu7qSyMk70gYmwjMzEv5Pny6dY0ZRJei+cL5BCml4n7
         V4GSsNZuZ1BA16LFCmOKsq3V+IEkI8zWXs0uSR2G4W6q6KiF61y3NKKzW4iTbfDyFyJV
         RLzAVKQtYKIm4+7isVkzGMOKl0yHgn2GDyc/BRRa7IvL5PRLxIPVuhKdCwMfjBZQ8Omu
         PVzW2IL7WOTcshH3qsXI4ll3QsXjou3GGTj4NueHxC5nrA9SaL7DcIDBYTCwvtkrYWtc
         X70jTpyJUsKq0QBbmoDNM0GZsXDqxlDA+INV+GkuGPOXWfUU2t4CJwpOM2BAaMaqEOd+
         Rv2g==
X-Gm-Message-State: AGi0Pua31Ml1bsi8py3mQ3G8VJZgar+oFADNnm/nNeyc3KrMo1i0xBFK
        /73zhyvPKU8UKHCVIyMUsSqRYA==
X-Google-Smtp-Source: APiQypKJmeTbRVpekRlRZX2ChMEx0WDcl6JX+ShhzejzFCOyGuQBkN1mqfwiMRrg1Cnf8jtwyxEEXg==
X-Received: by 2002:a5e:9518:: with SMTP id r24mr4292114ioj.209.1588345538701;
        Fri, 01 May 2020 08:05:38 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i20sm1047218ioj.14.2020.05.01.08.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 08:05:38 -0700 (PDT)
Subject: Re: [PATCH 0/3] small fixes for-5.7
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1588341674.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f621d20a-b81e-62ec-1f5c-a81bafa4c9be@kernel.dk>
Date:   Fri, 1 May 2020 09:05:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1588341674.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/20 8:09 AM, Pavel Begunkov wrote:
> I split the sent patchset, please consider this part for current.
> 
> I'll send a test for [1] in a day or so.
> 
> Regarding [3], Jens, I haven't looked properly yet, how long
> splice can wait on a inode mutex, but it can be problematic,
> especially for latencies. How about go safe for-5.7, and
> maybe think something out for next?

Agree, let's play it safe for 5.7, and look further into expanding
this for 5.8 so we don't always have to go async.

Series looks good to me, applied. Thanks Pavel!

-- 
Jens Axboe

