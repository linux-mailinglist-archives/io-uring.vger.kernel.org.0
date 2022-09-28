Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE34B5EE2D0
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiI1RO5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiI1ROM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:14:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2203EED5DF
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:13:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso3204011pjk.0
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=wWlQ9VK0DD9czemBerx4SeOis5QOOAIANjEKI2qVGtE=;
        b=cqKovKCQW42IllwbMKlBvvUs/FTWNZj2mcCK4y8ThaGVMsyk99k64owZjUZ1wWxcQ6
         nYikmRHFfUAOgeWZGS+Nn9LoJ8ZbviC192qAAj4lWH/thexYx83hrfTITHakHOENrtxc
         zVPqhWKPDZON3vonUHsXNxB/06q2VX4xHkzzWTZ62frKoxiIVahORXc7MJfSDedHTM4s
         zRsfCkZ8dIQ5YcJrh2KGXCJbQ37RZW2Tk7wXLqPTvYW2cQ9wGtvzCEWMqM3gp84kDF5e
         3Vqks9P8ozmtfwHJhhPD3yV6cRuVrPJNwa2MleHi5Ry/pIgPG35wdEOx+1G7zOrTFGJ6
         wxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=wWlQ9VK0DD9czemBerx4SeOis5QOOAIANjEKI2qVGtE=;
        b=vJo68ZOAtLt8KJvwLXe0KvfoWrYrjkldegKi85ru1vzvh1UHbbcLgQjPg9NFz1ZADY
         CJDhD2JqK25sQfbKtDd7gkzvnmgMMrDN8eF4KH5XR7xKRkCVwmB0t4/XcbZEtreyjSFw
         igVlbg5iQzMP4vszGubS/Y6UaJ3pbivqJRbGdSW6Eg+cNYY+sqZV8dCwcyBxNBeX8vdh
         ONr1/iWoB38qFTDAsliyLXCuILK8UyxyfJyUav+caxBrrU2hd31jzSSVJ+fgQf/0L6Z4
         YJKgktzWdpEASphyLreaZorfQxIv2nIBX6v2Ii74Odvoz/dEArGz8CyeZrP8gb+bMrWR
         Z1gg==
X-Gm-Message-State: ACrzQf0oh61mN6HZ8jiqnFK2jRWA2M7yxaEWXqIjBkpTaFWYpYlUqE3Q
        YpNWW8Vc5DmUIydq+YhZkx5mKw==
X-Google-Smtp-Source: AMsMyM52hwd593t/SShjlopLYj42VgkbaQcw6sT5ciMCuzKacBGMa3jiLUuF7+xtWM+y2NRNlketfA==
X-Received: by 2002:a17:90b:33d2:b0:203:15e7:1571 with SMTP id lk18-20020a17090b33d200b0020315e71571mr11445784pjb.186.1664385216734;
        Wed, 28 Sep 2022 10:13:36 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r9-20020a635d09000000b004393cb720afsm3844788pgb.38.2022.09.28.10.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:13:36 -0700 (PDT)
Message-ID: <3a8f1bbb-7430-5bb5-351f-45f46b09db5d@kernel.dk>
Date:   Wed, 28 Sep 2022 11:13:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v10 0/7] Fixed-buffer for uring-cmd/passthru
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220927174622epcas5p1685c0f97a7ee2ee13ba25f5fb58dff00@epcas5p1.samsung.com>
 <20220927173610.7794-1-joshi.k@samsung.com>
 <96154f6c-c02a-4364-c2a8-c714d79806d3@kernel.dk>
 <20220928171244.GA16907@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220928171244.GA16907@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 11:12 AM, Christoph Hellwig wrote:
> On Wed, Sep 28, 2022 at 08:28:02AM -0600, Jens Axboe wrote:
>> Christoph, are you happy with the changes at this point?
> 
> I'll look at it now.  Too much on my plate for less than 24 hour turn
> around times..

Yeah I know, I believe Kanchan is OOO for a bit from today which is
part of the reason why it got quick respins.

Thanks!

-- 
Jens Axboe


