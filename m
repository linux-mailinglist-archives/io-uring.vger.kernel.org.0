Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D79578758
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 18:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiGRQ1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiGRQ1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 12:27:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535DC2AC5C
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 09:27:06 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q5so9484064plr.11
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 09:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H5cFyysoeTQyXDxMaPkX9P458DIkopQ0kteqyRLVvVk=;
        b=srwJ5unZpe8cCGvbxFkxoG5xA8CCLaXd6hjT6r4UJqAC2Dk9lZ8cZn7M345y7IpwC7
         eaVrgXjwmBbdGfryzKzSWAUwlRSzK9XX35rLtK1XImEo8uLmhptnasNHtST0h7t7W59P
         CfucU3MJ8Kyry92SVGq2s93lW/DnA5oCb+Udj1nd8bWb/OliT7ajZdhytXxoIRjRcBCu
         wIIvdjXEQ2SKG6WM/MmawMJIXrWOI1lwytMLB2tDuWh8SOjI/AahEDwElobD98F5qpDN
         VlMKI3zwfaUQy1GFX+/E/Es1LQGPrJBC+KDdXkV/FOZ//ALPch62iMa2lnuKJF2uDR+b
         vs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H5cFyysoeTQyXDxMaPkX9P458DIkopQ0kteqyRLVvVk=;
        b=X7qGy8pYMSP18hBzbhrOOGsLG7WpvOGItzrcR2N0a5X8UfTyfK2Z/OJr+5EWYMk7bL
         OZX6CZgfdpcmvDhneSX7uvuyeATHmYcskf9opHtaVfEx1ZcKS6x8es0VGDDQzOCtwFng
         x8FXAsQY4IxPKyNBNha1wYTzhtrfHSxO5db+DuHN91uDXhQx02vWDeh4a4OCcbgWteeK
         03wNwNUf+iwYUe6YYI6U+OU5PyT0IWb4AztyX0k89UutxNBs2MyyBpRguKxg6rvJLytm
         Py/71snDg1VcU5r9XIdlS+A4ToynknLK+VpMIWni0BYWY3uVH0Wxy95re0oRea0jRuN6
         uPyw==
X-Gm-Message-State: AJIora+Xl9Yc3NelGoIXb7/eficEA+tafEbv2Dom5ZywZPpIY2gQQKXT
        wxJA1xZPq3LxuaxSo/ZOKs55SQ==
X-Google-Smtp-Source: AGRyM1sxVrWyI5XycSgmQCI2aYpXen9m2F2n99d+l9K7vIS2GIdNeVpz3cWYni+d1fP6RBTgZozOgQ==
X-Received: by 2002:a17:90b:3a88:b0:1f0:56d5:460e with SMTP id om8-20020a17090b3a8800b001f056d5460emr38485602pjb.208.1658161626338;
        Mon, 18 Jul 2022 09:27:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b0016b68cf6ae5sm9701133pll.226.2022.07.18.09.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 09:27:05 -0700 (PDT)
Message-ID: <7146c853-0ff8-3c92-c872-ce6615baab40@kernel.dk>
Date:   Mon, 18 Jul 2022 10:27:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
 <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
 <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/22 9:30 PM, Yin Fengwei wrote:
> Hi Jens,
> 
> On 7/15/2022 11:58 PM, Jens Axboe wrote:
>> In terms of making this more obvious, does the below also fix it for
>> you?
> 
> The regression is still there after applied the change you posted.

Still don't see the regression here, using ext4. I get about 1020-1045
IOPS with or without the patch you sent.

This is running it in a vm, and the storage device is nvme. What is
hosting your ext4 fs?

-- 
Jens Axboe

