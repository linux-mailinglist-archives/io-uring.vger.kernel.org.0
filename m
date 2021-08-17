Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D068E3EEED8
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhHQO5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbhHQO5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 10:57:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076D2C0613C1
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 07:57:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w6so18154856plg.9
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 07:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1HdHdFgWWG16f4VwNP1gm3a1IOgD0fTv+SrBh0by7IQ=;
        b=kIWcguE/I/iMCvSQVpeRfXxGl+9A/JDtLbRLkJ78gUb4+3IGvFXFEISYOyD0qtOoQw
         PlcIeo5TMWaWuqqIJv0rLLYW5hfNDtC2CFas4gi7MX0tmJWmg6lv2bUGwhA3NAcRCTZ4
         FNPpuWsl4pTjOPGM0iJsazx0F13+msWdp19otXXzaHQtBrsbMW2CtF1GfA/+91iWF1En
         83/qwC6pJWPlaH4cgixns7cYJxT9Kdd42q87YiP/sZZcO/rbqrXs/+KkW3Er3o16MIlH
         fT585xGuubJpw3LigCirvwB2mcq0XpKqqlLYUu9zAmsBJTHD+t8N88xI0Nmd0k6VoCVL
         tTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HdHdFgWWG16f4VwNP1gm3a1IOgD0fTv+SrBh0by7IQ=;
        b=Hg1OumuL5ADuqZUFlDavokPCEt5FZEf8vCUz1+IM0m2n8PVE3Xx9XixPLApgBXakcE
         lgoNLWCfP/odBAvFgkdzH62OryTXdY7DmC4Q0igm3+80pF19M/AYNYt/ko5+puMlayMX
         tLVw1RMfpoTbJHKIDgf9QBzHJ3+1FZugLamcnmUpmsJEUdslE69UNGcl/uPjVIO/zXT8
         n+lcXL5SIZUXq1Hm/gsbHExxXKOhUvafsq+KuFSyYk3Ls0VhfVgVufA+ma7PcdErlByq
         5V9taEviuBBR05nVNQ+scUKOCLAeX2yC1q6n1LZRJUXvmp6Lo4m1uQd87qxf2w/muqcr
         zQcA==
X-Gm-Message-State: AOAM5303fgB2FKe3MhYQzsApMY7bzQ4LBQICbNuNTjKbQIqyLHzy1R0P
        DvxZk8axeEF5ziFmLREkGoXkQg==
X-Google-Smtp-Source: ABdhPJzg+/VFD0aZP/K9KCbnHrNFCT23a+Ea9PjuGgTaDiY94Y7TQdd+JR0IL4r+V2M3pkN2Z6JMQg==
X-Received: by 2002:a17:90a:1616:: with SMTP id n22mr4140488pja.141.1629212235318;
        Tue, 17 Aug 2021 07:57:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r3sm2909972pff.119.2021.08.17.07.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 07:57:14 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1628871893.git.asml.silence@gmail.com>
 <17841c48-093e-af1c-c7c9-aa00859eb1b9@samba.org>
 <78e2d63a-5d3a-6334-8177-11646d4ec261@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ab450460-1faa-dea1-f8a3-894a42461597@kernel.dk>
Date:   Tue, 17 Aug 2021 08:57:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <78e2d63a-5d3a-6334-8177-11646d4ec261@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 3:33 AM, Pavel Begunkov wrote:
> On 8/16/21 4:45 PM, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>> the old behaviour. If non-zero value is specified, then it will behave
>>> as described and place the file into a fixed file slot
>>> sqe->file_index - 1. A file table should be already created, the slot
>>> should be valid and empty, otherwise the operation will fail.
>>>
>>> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
>>> accept takes a file, and it already uses the flag with a different
>>> meaning.
>>
>> Would it be hard to support IOSQE_FIXED_FILE for the dirfd of openat*, renameat, unlinkat, statx?
>> (And mkdirat, linkat, symlinkat when they arrive)
>> renameat and linkat might be trickier as they take two dirfds, but it
>> would make the feature more complete and useful.
> 
> Good idea. There is nothing blocking on the io_uring side, but
> the fs part may get ugly, e.g. too intrusive. We definitely need
> to take a look

Indeed, the io_uring side is trivial, but the VFS interface would
require a lot of man handling... That's why I didn't add support for
fixed files originally.

-- 
Jens Axboe

