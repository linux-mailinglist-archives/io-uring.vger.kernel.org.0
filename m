Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97711F8995
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2020 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgFNP5A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFNP5A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 11:57:00 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE12C05BD43
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:56:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so6709609pfn.3
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9sXkYkKOlOxSWFM8JwS3FTWqYj5qlsvdAcv/SJkFUYc=;
        b=l62Wy9Yk01krE3zybWr19ZfpsscVy2LPr/r3PqnBEj6p/kmEVSfDkrfIJ5cQaNQ+00
         pdzo8oqS5ESOZXuL99SMRQZOHg/donyHOMEfwOHtHhyg0igXwQg9Q5c2+3sAJf6pTJsO
         bGYGEhflwBk89LpRzTt0MMY95SqPNPgLRgqDx1oc5u/71R0gd2LWEgoKmqVnsCkOQA1a
         oIwLCfvCa3LdP35eFcUbbYwIxxSb3p2dQETjA5Q+0ykI2kAQko33oADSAnFXCE8hzgbD
         efuRR/KG4YBvS+8t2dnE6zKVugmPK+8v+4c7djTMRalN+/BorBZ8FQfN2zcuoiAXwfiH
         Q5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9sXkYkKOlOxSWFM8JwS3FTWqYj5qlsvdAcv/SJkFUYc=;
        b=sINDObjYkV7VyFJIbJR0UQRCBk75T820sIMpMh38+F/U6wc5KVvtMnEkFbsKiZeTSC
         i+x5ppyCgs/gLd2qk40dnrVPVx9nhUPPZZoZJfhb04vYMJjQG9St9w+J61kVPv87SdYz
         aSDLqiMxVOyZJyp3JDJr68B9L0KF/YySBTd195UpilOkuILB5aCO/Ytyrxb59ANUQTFb
         34H44aJfOyG1rKF27rQ27u3t7jYYyxzxDJ9UbV3WOcuGWU9hwGnf+sQRPyy0WwlIW+sN
         f/qyPRmM3wpHM+RUWqoepj/sk+djQuQbsSS9pENktYP0QiXHflqUgYY9vugmgOX5B1r/
         Xwyw==
X-Gm-Message-State: AOAM533J863nO/g8IlCNVjwjyRdUh5ZfQT5bT5/cxkzz5OLFuvWt7tjU
        ZKDPhfcLbKNMuYGyop7A/isTEYKKciv2aw==
X-Google-Smtp-Source: ABdhPJzNH1ykiqLplGsBvurimoy2qu0FtMDCGwPhh80Rq/oAAVIxEoaIi8EI+szMGNkEeeSAXhtkEA==
X-Received: by 2002:a63:480d:: with SMTP id v13mr18942629pga.286.1592150218326;
        Sun, 14 Jun 2020 08:56:58 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z8sm10100506pjr.41.2020.06.14.08.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 08:56:57 -0700 (PDT)
Subject: Re: [RFC 1/2] io_uring: disallow overlapping ranges for buffer
 registration
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-2-git-send-email-bijan.mottahedeh@oracle.com>
 <b33937c3-6dbb-607a-d406-a2b42f407d86@kernel.dk>
 <fb0ec799-a397-ff7f-531d-6fcf8d5883cc@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f4074b36-a87f-ac17-d683-0229f8b88cb8@kernel.dk>
Date:   Sun, 14 Jun 2020 09:56:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fb0ec799-a397-ff7f-531d-6fcf8d5883cc@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 12:22 PM, Bijan Mottahedeh wrote:
> On 6/12/2020 8:16 AM, Jens Axboe wrote:
>> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>>> Buffer registration is expensive in terms of cpu/mem overhead and there
>>> seems no good reason to allow overlapping ranges.
>> There's also no good reason to disallow it imho, so not sure we should
>> be doing that.
>>
> 
> My concern was about a malicious user without CAP_IPC_LOCK abusing its 
> memlock limit and repeatedly register the same buffer as that would tie 
> up cpu/mem resources to pin up to 1TB of memory, but maybe the argument 
> is that the user should have not been granted that large of memlock 
> limit?  Also, without any restrictions, there are a huge number of ways 
> overlapping ranges could be specified, creating a very large validation 
> matrix.  What the use cases for that flexibility are though, I don't know.

Not sure I follow, so I must be missing something. We're accounting each
buffer as it is, so how are we abusing the limit?

My concern on the overlaps is mainly that someone could be
(inadvertently, perhaps) doing it already, and now we're breaking that.
Or maybe that are doing it purposely, for some reason I just don't know
about.

-- 
Jens Axboe

