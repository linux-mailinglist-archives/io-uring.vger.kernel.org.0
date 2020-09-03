Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8DF25C078
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgICLlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 07:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgICLkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 07:40:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FA8C061244
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 04:40:33 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u13so1932382pgh.1
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 04:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BbEzMsXeJFMaOZkE8yoL1Se14OvSsVtVf2jVI5mEwnQ=;
        b=dpnMey+jlMM0j/gJQ9QAiDjtIYrat8OUFvlc7L+FKZ++IPczlrPxzXYPACdMPWqVLr
         14NStW4AIZuRWw4tzCJ267i/7NLt7KjpxBnheTM+KBpzAf68rzBKI62764daDf0YFSJ7
         1ga2gqBOTbwNIQ7LxmeLSBR/PRQGYVYRURg2QzPaObAV/V32LJe0+IBAvrxTJQDLYTp8
         ySWoqA1eKZ1qzRepgyQy1kusDpgoQtxPAtXaSZ9HoDHgOdx2du95FQFIoKvw4MfTZ/rs
         7P917C7O34SqumVUSZlUoOfjmLK3niYTG7vpIpCuf9eJQDo836iF0K0nrl8aO70TCGOY
         AOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BbEzMsXeJFMaOZkE8yoL1Se14OvSsVtVf2jVI5mEwnQ=;
        b=uY5GOXBnSE3Kyj4NcfAdtCpdLJrN9tsFRHG5glyvdCzIf1y9xY5MhcVIkZSETxvJ+b
         Xf06cmofqbXTSbWd+2vl8Y5zhRck6FKAEClwBAQ+0D8FBDtEvgrppr/nLumuXe3OJiR0
         NnPzw9iJOeBXpyqZIU0Ux/WikjaiGmGAZFYO6YgY0m2KnSZ5NC2SXXDxgAjZP0N4Z7mn
         eaUFEVtKNVLhQmy05LWDCGjq/fd0U4eC8ORcC/2EFCm5EjfCoHJ4M7Xv+o/azdzTBXiw
         RVQguqtWmvzf24r6rm6MZZ+gNHHURK3+GQSe1ZuGFoXbEoO9TWtMcSbIVvleWt7CY25d
         8lhA==
X-Gm-Message-State: AOAM533AvN/IWgHpCYyfyQNdPrSTjkvrGDnqeW/IXFluxuLH/yn/sUTV
        W48H+8ybkaI4Kn6Ey8NS8/Wmz3sTYOsZoUBJ
X-Google-Smtp-Source: ABdhPJxh2F4UwSxA1zfApE3Z4knIzbl0WGRoNeUyajFRr3H03XMOuK0xNCEQIOS1I89yP7vLFYvNlg==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr3484123pll.140.1599133232465;
        Thu, 03 Sep 2020 04:40:32 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mp1sm2453694pjb.27.2020.09.03.04.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 04:40:31 -0700 (PDT)
Subject: Re: [PATCH] io_uring: don't hold fixed_file_data's lock when
 registering files
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200902113256.6620-1-xiaoguang.wang@linux.alibaba.com>
 <a8417eac-3349-cc82-7f13-cb00fa34617b@kernel.dk>
 <b16114c8-7369-d6db-ceb3-2fecf3f020df@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b698dd1-3440-3fcc-bc4f-3e9e48b029e2@kernel.dk>
Date:   Thu, 3 Sep 2020 05:40:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b16114c8-7369-d6db-ceb3-2fecf3f020df@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 10:35 PM, Xiaoguang Wang wrote:
> hi，
> 
>> On 9/2/20 5:32 AM, Xiaoguang Wang wrote:
>>> While registering new files by IORING_REGISTER_FILES, there're not
>>> valid fixed_file_ref_node at the moment, so it's unnecessary to hold
>>> fixed_file_data's lock when registering files.
>>
>> Even if that were the case (I haven't looked too closely at it yet),
>> it would a) need a big comment explaining why, and b) some justification
>> on why this would be a change we'd want to make.
>>
>> On b, are you seeing any tangible differences with this?
> No, just found this by reading source codes.

OK, then I suggest we leave it as it is. The data race analyzers wouldn't
be very happy with it either.

-- 
Jens Axboe

