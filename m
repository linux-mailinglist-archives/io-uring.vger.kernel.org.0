Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5463FCCD2
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 20:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhHaSRJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 14:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhHaSRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 14:17:08 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614FC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 11:16:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b6so456998wrh.10
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 11:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZPG+u4nHkPtKxoAgq7OEtF/gz3VdZybREW5k9a4ZT4A=;
        b=FJF4G8AfYZ0BMC393SdzHB18RDFM0D92hEBCo7rdhWihdgoXrwj0hrc4/TfQWxgEee
         AKeVr9nutqcYqDI6S53He1qnfytqubN3MnypCwLfk8jTtWX6bn+KUop1MR85wr4IVzAt
         ePtq1xjkPN7Z2j8Q6NcVt58rSbCNclsVU992ZQrUKA43IiR0TdPVKrND2/T/zBA7ojfw
         UMMOL/Kq6LZQU1kWQVGPlJflHh1It/tt+BA2BkhaRh0poSlQ+WXjPjCoeTSRIL+uTL4H
         VEANjbt7/9p2eVW8CvLk8v82kwXmpES8BnIsQKjn/ktKDmNE76C5ncbNF/XdziD+RpYR
         cMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZPG+u4nHkPtKxoAgq7OEtF/gz3VdZybREW5k9a4ZT4A=;
        b=LgmZWHZdhKyTDaqh0louCLThcqv54+SlsI9i7tzuFa949pnAfJF5Yr9EsQl0JA54/7
         sEA+L4cfatnmcRB8RfDnGsQXF57seBhOu0YOMKeIZpIgt2hbhaprQTS27/q6W1TeDEz3
         yD5Gf7SLHWP54cdMrmT7r15jaCBGsXbj9wMyY7q3qSk8WuezFvto5572gcVMmo5L0vf7
         PReEWwYIpDYGMO8K8OuF6grgndo+a4VWpLtyXjh5OaDw2lxAWTpM+vHd/0keKNqj9FZX
         tmcfyFF3hxBiyoTiPT6864toTIDpzIHQB0lSWQEH1/Qpbz6yF+z61Q9SVCOKZNI41/Hw
         YY8w==
X-Gm-Message-State: AOAM531gwk2o3P2T8sOYec8qo4+1LJz/YdZjrHk6YUBd7LwEfzFSQ0Fc
        +8oPyTBnpiAJZG3EGq8VCvVdY+snk4I=
X-Google-Smtp-Source: ABdhPJxezP/IYopoV7vXDptZNna3L5giIawmI10XKwRyjZfOry4ggrOfhj0rKhy5tOHFh78PRevtuQ==
X-Received: by 2002:a05:6000:352:: with SMTP id e18mr13985759wre.238.1630433771963;
        Tue, 31 Aug 2021 11:16:11 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id s205sm3228431wme.4.2021.08.31.11.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 11:16:11 -0700 (PDT)
Subject: Re: [PATCH liburing v2] tests: test early-submit link fails
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
References: <3e02f382b64e7d09c8226ee02be130e4b75d890e.1630424932.git.asml.silence@gmail.com>
 <d813efa3-4391-2e3e-54d4-a9dc3e346511@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <dc45d3e2-b1b1-b5df-ff8d-a886cae261d2@gmail.com>
Date:   Tue, 31 Aug 2021 19:15:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d813efa3-4391-2e3e-54d4-a9dc3e346511@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 6:03 PM, Jens Axboe wrote:
> On 8/31/21 9:49 AM, Pavel Begunkov wrote:
>> Add a whole bunch of tests for when linked requests fail early during
>> submission.
> 
> Applied, but remember to check write(2) returns:
> 
> submit-link-fail.c: In function ‘test_underprep_fail’:
> submit-link-fail.c:80:17: warning: ignoring return value of ‘write’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
>    80 |                 write(fds[1], buffer, sizeof(buffer));
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

My bad. Interesting why my gcc 11 doesn't complain.

-- 
Pavel Begunkov
