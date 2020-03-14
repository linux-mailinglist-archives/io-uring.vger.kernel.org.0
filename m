Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1279618583B
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2020 02:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgCOB6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Mar 2020 21:58:25 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:45392 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCOB6Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Mar 2020 21:58:25 -0400
Received: by mail-qv1-f65.google.com with SMTP id h20so2982335qvr.12
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2020 18:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SdOYsMZFDHe9vqNvSdxRkcSwQBXCi2657j9Xa2tK9oA=;
        b=xgAlfPF/jH19mCf3oilauqnvertvFGN4reqpz1II3RvLTUdEG1XjtuLT8GB+7rw/DG
         ZzU1/5ECQCzgWimMdZiq5PqAGKOk28z0eOks95Ksf0BVFzH+8qujmfqN9KJ3Cl4iKO3h
         5Ca0xO2QG14yS0E6801I5dT6odvBnpqmEDYRU6fZC0ZwEvPRNrxJ5vG+99jI/DBYxSUN
         KdG2cWMcoWd6plprhdjoQZD4Y0jM9jZFSvU73u33d7mEyvCpLxv3pOSAL9tRBVI8E1DK
         hZ3Lwvu41Jm6NJsEL8pA/aqJsnZwC3AenvE05fCvwm+llph+hEg+oC7T4/CjW8PzaiY1
         +6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SdOYsMZFDHe9vqNvSdxRkcSwQBXCi2657j9Xa2tK9oA=;
        b=HqOk1IrlmaU2iNSL+MVHEoycW53lXY1geUNtJKdxC4SHNrIRZ5XVyf0JFfPQJRxzzv
         /i11u6LlyAvV98lPkIQwfil5lHoyJN1mhuw4VnW5Whh/pMCwQ1Q/dpOo9O8cxrG11n1f
         EIlkKMvg00lrUmiwJcaRHjObUu1p7A+Xiu7TyrB9txK1EU53wQCjUTeBMvsOERgJbecs
         G1z5bmQCF3BMi3jfIoHZLvA9UA2tT0itw3v9h8I4eCfokejuCyR/MXqfEa1d6OciyHSD
         zHrlGd4aA7nLM4NppD7DTf0IDT25OW3gn84qwtZ2c4B4alIGrXzb7y2TxSqJ6CQmuF1m
         y2XA==
X-Gm-Message-State: ANhLgQ0tvgcixrd2A6oOMBXWExMX0NqHvTVdsndCtbSTiR1W0Gr/2P5e
        bp7psoCWWk3XsBb3db7+4Dsb2zR2L1jR0g==
X-Google-Smtp-Source: ADFU+vv8d06cooYnEyYmyLwJ5MAPGncbMbhQYSytgYgCc67JuVz17NdDF+7aY/joqlDV2aEOjDBwZw==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr20495125pla.326.1584227898541;
        Sat, 14 Mar 2020 16:18:18 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm15469459pjv.32.2020.03.14.16.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 16:18:18 -0700 (PDT)
Subject: Re: [PATCH 0/3] support hashing for linked requests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1584130466.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6af1ae2-dfdc-00b3-4b33-f6d5a2f63f0c@kernel.dk>
Date:   Sat, 14 Mar 2020 17:18:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1584130466.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/20 3:31 PM, Pavel Begunkov wrote:
> That's it, honour hashing for dependant works in io-wq.

Looks good to me, applied for 5.7, thanks.

-- 
Jens Axboe

