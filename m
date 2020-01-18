Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A663E1419AB
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 21:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgARUqS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 15:46:18 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40668 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgARUqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 15:46:17 -0500
Received: by mail-pj1-f65.google.com with SMTP id bg7so5066492pjb.5
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2020 12:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9nGxRoRYyJbnnwOrpQGmTmHPjg5LAsfCWJ/kF5ALD1c=;
        b=B2jmbkHRX/6OAJ3J9TuDRJDwLJP9i+J0xOs/l8MaJ6yLbqPtg+H3sPVxzDvmJfsvk1
         G3gjA2wSOd93b04nIHXqvTZj7lZklbDxngWulRlMu0TY2MrLURgiXzSPZDvbPL5B5kk5
         nbm6SZVXnQJd5+RS9i4fDb77UKUSE0TsP/gH1IJQ8aNVfLHN6Xp3iWgAiDO/fqDhIg5p
         4aoPdYv7lka7KDH9U6RclFBtLoR6DkkxGv/AqcyHgPmY4yx8xhlEop735ZtN70Gfejvb
         RKfuaPutAy+00ct3U2y2okMI9F+dLr9qA99rWvb4TyR/h3eNp8tu5BXl7sv1l7wWx5AI
         ptTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nGxRoRYyJbnnwOrpQGmTmHPjg5LAsfCWJ/kF5ALD1c=;
        b=gEyX1iWWYlXQkhMp5enYgONH35y2b5Dd0sxEuDIiGSoS5U28dKO2GUr2YBNKwtiQaK
         VPh99Gvy6mPXdjYUeosXI6Fy2gYoMmbWZmCYuwXm99y2yz50HAiNII73o8uwYJS88UHi
         HY/fmhHSSkp30gaAlDsi/ENzL7kEDmcHTMwm4fP3iGhFlEP1akhFFagUztv5ugiCmhBQ
         6D0jr/8XoFNLbFB3/xAjCf3N/ZmC4kJ47PpdtJJw4nmses464VyXWc4CAP79r5BN5aJs
         dJ0hmJ2fs2PSOAs1LkZuv5j0k1nul0JneLpsugh3Gei0Ht67n2Si8mdWHfco9qKSe7ZA
         WM1Q==
X-Gm-Message-State: APjAAAXdObHxssjMLuRpChlkvOajgpWMmzO5yqqOPOfMAMxwGQX66RId
        D/NCtpuh1bOogcJu8CKn2JPSrxXq2dA=
X-Google-Smtp-Source: APXvYqyBGKSzq8EJexVFGiEYgwUBYmAdWpzBit4G++aNEoxZ3QyJwCMlQAsDrYDdeEXAAiq0s4UnAQ==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr14244745pjf.120.1579380377239;
        Sat, 18 Jan 2020 12:46:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m19sm2528305pjv.10.2020.01.18.12.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:46:16 -0800 (PST)
Subject: Re: [PATCH v3 1/1] io_uring: optimise sqe-to-req flags translation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
 <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>
Date:   Sat, 18 Jan 2020 13:46:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/20 10:22 AM, Pavel Begunkov wrote:
> For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
> is a repetitive pattern of their translation:
> e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*
> 
> Use same numeric values/bits for them and copy instead of manual
> handling.

Thanks, applied.

-- 
Jens Axboe

