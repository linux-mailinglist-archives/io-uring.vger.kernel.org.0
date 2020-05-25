Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047A1E14B3
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 21:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388838AbgEYTSD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 15:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389460AbgEYTSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 15:18:03 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42070C08C5C0
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 12:18:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p21so8964747pgm.13
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 12:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UJYUCfcFKSjibySUQWdcBfa53RDSKNSd60YzQm14ihk=;
        b=EtDBX0gxOGHGkQ3fkaimTlLoFV68ZTx4tlcbM+sFENyB+sE68GrafHqCOnZXD8M6ZU
         0MLL9agTf/8QcRRJOCLkhqONSHWGQaO4/q3j7sSPay8ZN72GAx+VqZC/EVLOOp0701m1
         tWDbFfQcvoqzvf6NU++n0xvgDgNURnC2qnjXKZugv3DiCSn+KYOyknQJe406dQfX2c8A
         GsiwV+nDCdUGuDXA6Dci+gUa5zW7km0BtVNjuiuHe8+uO+IMyOMmvqoK0i8XVZhEA3hi
         syrna8O/zKyxoGmM3VsrTKZp9UwbqFdPQ0bf7VqMfeiqy6UiUfX+Gjil9a7BSrfz6d95
         +oFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UJYUCfcFKSjibySUQWdcBfa53RDSKNSd60YzQm14ihk=;
        b=nywpU89atJyFAUb1Sct1eTWSYC32xzYnuTE6RkyAhwM00gof9G81xALzOeWJBoZyf2
         CQuarvU9VwB6PwSzE50LbAtm2ucNJDftRpw7nKhZ/v39MmFJHOmoFTRhGacZvbmkOE5o
         DwyCfiHei3scicTOIMydaMzkqMyOJWDiPS+18mnkiWukq92vLpnkv4CYVOfB/XBuzxhs
         T+H9hjl/p4jPo5XlZ+fc58SZOAdwXFFPQRUSOPcAx8Mip2V/q0jh6oIs3dPlFDEefi8h
         +3GosX5BFZhHgT5V9K1/BYD7tPL12Y4LM4RamhXzMBdo+aPgwOGwSArDTdQ0gJzeIrQk
         a3IA==
X-Gm-Message-State: AOAM530PMfJYElxMarEa2Ec+jX+LjLrki8AzvfqNSwrEbBdgOHWHEI9R
        ce0AAgo6Uc+XTWE7Y81PPinu185T7rLudQ==
X-Google-Smtp-Source: ABdhPJxT6GwI/r9SL3Zhwl9SOogxPujQGdCNFPfkkYkHfgq/I7sdK+kmj1Q2O7JI+atvV/a72X29tQ==
X-Received: by 2002:a62:168d:: with SMTP id 135mr17459490pfw.239.1590434282407;
        Mon, 25 May 2020 12:18:02 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:3c00:cb1c:41a3:c8d? ([2605:e000:100e:8c61:3c00:cb1c:41a3:c8d])
        by smtp.gmail.com with ESMTPSA id z20sm12226091pgv.52.2020.05.25.12.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 12:18:01 -0700 (PDT)
Subject: Re: linux-next: Tree for May 25 (fs/io_uring)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <20200525224923.41fb5a47@canb.auug.org.au>
 <7fbfc86d-bda1-362b-b682-1a9aefa8560e@infradead.org>
 <f7a9445f-1619-08aa-3e98-5bef9e4409df@kernel.dk>
 <785bc7d8-7402-c876-6fd8-708c7ccbcb5c@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f80e6229-ad84-3a0a-1566-772b4fa0c3ee@kernel.dk>
Date:   Mon, 25 May 2020 13:18:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <785bc7d8-7402-c876-6fd8-708c7ccbcb5c@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/20 1:08 PM, Randy Dunlap wrote:
> On 5/25/20 12:02 PM, Jens Axboe wrote:
>> On 5/25/20 10:35 AM, Randy Dunlap wrote:
>>> On 5/25/20 5:49 AM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20200522:
>>>>
>>>
>>>
>>> on i386:
>>>
>>> ../fs/io_uring.c:500:26: error: field ‘wpq’ has incomplete type
>>>   struct wait_page_queue  wpq;
>>
>> Missing pagemap.h include, didn't bite me on x86-64. I'll fold in
>> a fix, thanks!
>>
> 
> I see it on x86_64. It must depend on some kernel config setting.

Most certainly. Updated branch has the include, and I updated my
for-next as well.

-- 
Jens Axboe

