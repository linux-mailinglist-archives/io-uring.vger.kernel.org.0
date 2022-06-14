Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BAE54B20F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiFNNKU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 09:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiFNNKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 09:10:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0212F3A5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 06:10:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y196so8525946pfb.6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 06:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0QSZk8y9iF48MQklFZgSjygKheSojbz9TEbfU+6YF7A=;
        b=j0i9YOd5XH+oiMTKYViqVl+baYyATtjL2hixNCpwio9NDVaag9oLC2Tlo2OQpPceDC
         G8DCdFKrCrqQ3+Zm/Cy6+TZiyuSEaJS6koKFuuNPek9dfcMRY1umFgAsnR5VcqW+6ZmK
         jEmD6+3+hmRn0hgqCV8ImTo9kzTmEHMEgV/fNxbdXZpxtI7dOYboJhs4ktj0e3NidwM8
         qrIh5TputVRkS7ohswVtBoMIlq5s92hOEd43hLwN8/guz7FLFayrxKRn12OSyBZswhU6
         XgP/ltOMf/ED42C/JizJkfxnR9CRJHkA1El4PtrjncSwuusPpNG901hh73NCd3KzOA7c
         kMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0QSZk8y9iF48MQklFZgSjygKheSojbz9TEbfU+6YF7A=;
        b=Lr/xYgvgl8uc2AhYRjZumb4Ua00dgAYrNuqwnj+KbyMislOx7ycqtFHXhO70M4NV66
         p+w8jJn5t9BBInFnf2tQ+BdEjuSq1BM/8R2Ddvg1TNMH9rBnDPW7wfoPmJiOhLKVIuur
         4vv/3Od4lkwDcQTajgwQ2Gv2Gc4e9Fenf82ky07c9nZmZ5P4edWbI+crflbZ5e3QnORZ
         fhNtAatQXXUu5VXNpOdjLKUCHNQ9i2SIaW9iGQpoIMkiXlEtvI7zCorXbpKDF4SpNcNq
         yJgGrgw8tTdcOjYt0Ra7/FsckpV74XW/MiFnu/UV/MMtNTZv9UrA7LJN5yACmkODkv2G
         hQzA==
X-Gm-Message-State: AOAM533FTSg3OnXcWkTOO4WHE+4O1sgeFRh6Ysk80kFpKKoe/X2Xyxiw
        Rkw5fx2NYKuZcOMJxsHm3sbIIQ==
X-Google-Smtp-Source: ABdhPJwVvk38G4BhJ24vT1TDKdiKUnrGxHnkeN/jV3lOSO8mEPdoeGOS25BpxjekCkvyNS4lrlheRg==
X-Received: by 2002:a63:1b26:0:b0:3fd:8db8:9602 with SMTP id b38-20020a631b26000000b003fd8db89602mr4538996pgb.239.1655212217706;
        Tue, 14 Jun 2022 06:10:17 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f9-20020a17090a654900b001eab99a42efsm3546161pjs.31.2022.06.14.06.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 06:10:17 -0700 (PDT)
Message-ID: <04651dc5-6caf-aceb-bcfd-fddf3f037a5c@kernel.dk>
Date:   Tue, 14 Jun 2022 07:10:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 05/25] io_uring: move cancel_seq out of io-wq
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655209709.git.asml.silence@gmail.com>
 <e25a399d960ee8b6b44e53d46968e1075a86f77e.1655209709.git.asml.silence@gmail.com>
 <33f6f7cc-b685-704d-dfc6-f8a1c0b89855@kernel.dk>
 <ad097aeb-d0f4-04df-c64f-3d6c69a71a0b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ad097aeb-d0f4-04df-c64f-3d6c69a71a0b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 7:01 AM, Pavel Begunkov wrote:
> On 6/14/22 13:52, Jens Axboe wrote:
>> On 6/14/22 6:29 AM, Pavel Begunkov wrote:
>>> io-wq doesn't use ->cancel_seq, it's only important to io_uring and
>>> should be stored there.
>>
>> It isn't there because it's io-wq only, but to save space. This adds 8
>> bytes to io_kiocb, as far as I can tell?
> 
> Ah ok, makes sense. It's worth a comment though

Definitely, not sure why I didn't add one... When you respin the series,
maybe change this patch to add that comment instead?

-- 
Jens Axboe

