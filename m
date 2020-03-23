Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C76D18F6C5
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 15:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCWOZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 10:25:19 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:53691 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgCWOZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 10:25:19 -0400
Received: by mail-pj1-f42.google.com with SMTP id l36so6255868pjb.3
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 07:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nlduzVPDyqKnPQVp9n4x5RYEfHbfM1LD5pCTm/+UuqY=;
        b=IDWjG6o5LDRvbGQOXpLg+YnM+AzoBkb4ouG7MG9W8lzvftXUCUBcfZpXbARvWYTtN4
         n4h5eEg4WtOpA8XBEMUmSMovg15M3L0/rx23P9J498bj0K8i54oZFwi95FQal9u51UB3
         ia5gADrJH7Ce6u3+oG8p4yuJxEMOadtAddmqOoM9OOUaRvcw4OQRqsOw2CsYXh9zVSZM
         HllWoTixA2RpB8wPcOriAxSbaW5DpaxDuZ41o6CBE+UkL7rWhVXKiN4p6HqMC1cWi2wi
         4AD+DdJzBInBij2D6Un5GO4dW64T5F6kGDuMP4KgJgxJtd+WDUZYhliyYVgQVAinzhtR
         t1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nlduzVPDyqKnPQVp9n4x5RYEfHbfM1LD5pCTm/+UuqY=;
        b=TGavE2oU2tEu0YEpvnX809BvzkP1PjIjL2OTJNc75v6oVQ/5WoGDVcn97XKto1m8NP
         SsrV5zGbL30jnyLkr+R1ToA6EaZmSDgfbM0otVJFT97jDV5zgYSX6WyQlznc1VF8L+5u
         7On5+h+JXzN2S2uXiLJSHcJ7jcHlJqI3vprYqazu299GyfN/mx7LwRz3CQ4b2SVP6TbE
         D4Xb4wynWJ1C/vyLiWq7kXfd7GM/Mk8j+IiS3bTuTnYZ5ONdOClG1SKUb5ny2JK3a6Zj
         GIN8w0Y0hs+FfPixsw4BAbPwKLCndSL01AW7QbV7QC5MBoDQVkqwr9UBHoUWnO6fLT0K
         hj8A==
X-Gm-Message-State: ANhLgQ2BBkccaSLtJK/NULKQwjJ+b4XuN9N49ORCEY5TseqRZB21Abl4
        rl+8aW9xwOTUZIJzTBOR58x/SA==
X-Google-Smtp-Source: ADFU+vu1RJ7BBqufFQRBaIpLy0UeR07UBFiFByXojwAY3z4hfmTLPSNu+/yA8Qa8vVOZwrs1sMpMgQ==
X-Received: by 2002:a17:90a:30c7:: with SMTP id h65mr26926351pjb.44.1584973516052;
        Mon, 23 Mar 2020 07:25:16 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x135sm12784397pgx.41.2020.03.23.07.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 07:25:15 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: Fix ->data corruption on re-enqueue
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
 <dfc0b13b8ccc5f7780fd94c1f7e4db724ac7513d.1584951486.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e48d707c-9ee9-a455-651a-85e16d11eb74@kernel.dk>
Date:   Mon, 23 Mar 2020 08:25:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <dfc0b13b8ccc5f7780fd94c1f7e4db724ac7513d.1584951486.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/20 2:19 AM, Pavel Begunkov wrote:
> work->data and work->list are shared in union. io_wq_assign_next() sets
> ->data if a req having a linked_timeout, but then io-wq may want to use
> work->list, e.g. to do re-enqueue of a request, so corrupting ->data.
> 
> Don't need ->data, remove it and get linked_timeout through @link_list.

Thanks!

-- 
Jens Axboe

