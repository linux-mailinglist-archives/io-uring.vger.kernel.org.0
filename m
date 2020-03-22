Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604E118EAF2
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCVRir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 13:38:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51354 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgCVRir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 13:38:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id c187so11930301wme.1
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 10:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bnS8jGrKttGro/fzm1oV6SHaxYM7Wmhg6g9Fccx2zTU=;
        b=YPMB1O2hpGIkUxdveYgbXk5hvZw+Xv/p1lovbVk/YHEuIPkiALJRwoXpAj7npKe596
         nOalA3jie2LPXeaner43Hay67hthr3Guu+fkP6NihI2z2VN1bHWw290tqyMIcc0vMN9b
         sADT4aDX6Sfph/3/apAH5od/hbY+v2YYteqzPGkp1rfugSI860fjvWv8jMN/pr7xgxp3
         V5OZ+g+DeupVaRm9qOb7X48586fWMyNWjM5iITdtBYlcYGf/gslECX8j0tZlV3jalfnX
         4V2QPt/2pVrKSxbwrHAtpQ76rCbPGJ4RUFoWH0vpmH1T5ZqBl9kywozPR3WncMG4wu4h
         UZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bnS8jGrKttGro/fzm1oV6SHaxYM7Wmhg6g9Fccx2zTU=;
        b=s8ajC8lK7KID7CxHoOl7fr5J+0bCnWo0aIA8kLao30E3AlYTS4Jp3WK9HCyWcVF8LW
         6iSUc25B6x9vcijRm9wZeTBe5D2Qzw/wtQGoydZ9sOUVUKQd4tO6zc5KeD6LgjJGcDAL
         5zNjjK1IwQepE9lVAfup7GH9aMPLK7ywrAEfBsV/nr7Mr1wp3RrmyRSeSNSydwgoYYlf
         OgrW+bMojwumwBzdbb+BshfGsndh9NQEp1etfMe3AUC6TilhVTuBY2mtjWGxRLSKmMYD
         54YIC9o5EukuAk54dZuUM2Aj1DUuMX6gFAx8vD+c1n+9LiBfDv9gvsFxwh1JOvNLUe8+
         Mu2Q==
X-Gm-Message-State: ANhLgQ1aNfUiVLFSLo6RSbkhoHBr/89KL36mI5A8VmE5tAQ7+d/4aJ/N
        DDZjyHCtrRk1eZA53G8vyxBnvMw+
X-Google-Smtp-Source: ADFU+vtfB38WbH+DzcZAuPTKuNX6aj/m02+C/GKNtvGnxOhqw7pa9BpEuK0U0R/gqHOmq0Otr33cYg==
X-Received: by 2002:a1c:e442:: with SMTP id b63mr23160509wmh.174.1584898724845;
        Sun, 22 Mar 2020 10:38:44 -0700 (PDT)
Received: from [192.168.43.200] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id c5sm20516609wma.3.2020.03.22.10.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:38:44 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <1c0d0978-0824-b896-d100-e0b7664ba81a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <097a0386-bd60-3d37-16ad-4053edb3c12b@gmail.com>
Date:   Sun, 22 Mar 2020 20:37:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1c0d0978-0824-b896-d100-e0b7664ba81a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/03/2020 20:08, Jens Axboe wrote:
>>> +				 */
>>> +				if (!work) {
>>> +					work = wq_first_entry(&list,
>>> +							      struct io_wq_work,
>>> +							      list);
>>
>> Wouldn't it just drop a linked request? Probably works because of the
>> comment above.
> 
> Only drops if if we always override 'work', if it's already set we use
> 'work' and don't grab from the list. So that should work for links.
> 

Oh, right, the NULL check is just above.

>>> +					if (work) {
>>> +						wq_node_del(&list, &work->list);
>>
>> There is a bug, apparently from one of my commits, where it do
>> io_assign_current_work() but then re-enqueue and reassign new work,
>> though there is a gap for cancel to happen, which would screw
>> everything up.
>>
>> I'll send a patch, so it'd be more clear. However, this is a good
>> point to look after for this as well.
> 
> Saw it, I'll apply when you have the Fixes line. I'll respin this one
> after.
> 

-- 
Pavel Begunkov
