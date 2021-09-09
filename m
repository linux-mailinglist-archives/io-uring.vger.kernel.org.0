Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE732405A36
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhIIPee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 11:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIIPe2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 11:34:28 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BB6C061574
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 08:33:17 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z1so2819476ioh.7
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 08:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WROY7DgvhoGuk+HALmk+3wBEauLCpqpBgBdi0y3KKNo=;
        b=bucR7QI6Fmw1N+dul5vEyrBRyAFLy6sZ4gjIluxxNM/gaUnxXzB6S0ot4PxE95gLG0
         pWmeOLTBT+cZ4Z4I6TNkYDKczYLKhaJbCSi0qRnw29ZOoje95gx2NTD5smlVrgT2+kQK
         oPVl8yaY+c9J4bw+C5XOm9GgFeTxthxnAzXU5K42uwDatFNlizn3qYv7g3BuDGgaiqVG
         JUaYJQxX046vcjCagz/arNDjVL9jo/1TNuaNKpobqVDlQhGjdUl1Nr/5WKZzCWnVkRj4
         xvWh0uJW2O3zFIN5hv4paa/qCOswst6K7Zq7KpX7Os342c9XH3xRAuG0Ql207qzodrPW
         IGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WROY7DgvhoGuk+HALmk+3wBEauLCpqpBgBdi0y3KKNo=;
        b=8Qlcnmp8jAB7K1RKdGT/fEubYEZ6R68Vjf6Ar6M25PgifmD3BPDNSEOFCpJDONmRx3
         hC2pp+2RifkwOfYGovwqXH9Hi2YCKBwkbXtkazwbVPoq8Z16BWRT4fpDTWjjUPinL4AE
         i6ACZ1+XSMHjlOQFH3zKlersntdn9RP459Rc0awBA9KpBT3+9+ncpN4Etf/mwHzrv6Ja
         mSvC8hhjZKRchbhb9ByY8lEgo4rtqSJLlDOPbJpucPuc+Xcv50FFdx86mmaZtZU8yEKf
         gY+8UxZHktro3E14mQxwQtYjDszkkCocM1npUjZrTvBbyGvBQXmDvh+aeeUF2KRU4CvG
         ecOA==
X-Gm-Message-State: AOAM532Yd8BX6eY+iiKO1xRYw+xgPnD0ignGfCEVmFylhpF+itV2WKg5
        QwH9oJD+p8lAbHbQL5QiKEptUW+uvcEhiA==
X-Google-Smtp-Source: ABdhPJwCLpLxD5sLVA+RKe3brdIbasWSCoaGuFdh+qU70O3lbjuUZCpCbdU8Y9mt+DK0vzHtn3X1DQ==
X-Received: by 2002:a6b:ce17:: with SMTP id p23mr3244746iob.90.1631201596528;
        Thu, 09 Sep 2021 08:33:16 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h1sm1026957iow.12.2021.09.09.08.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 08:33:16 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] exec + timeout cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1631192734.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <425d6d4c-5d43-4b25-f5a5-9a9129742535@kernel.dk>
Date:   Thu, 9 Sep 2021 09:33:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1631192734.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 7:07 AM, Pavel Begunkov wrote:
> Add some infra to test exec(), hopefully we will get more
> tests using it. And also add a timeout test, which uses exec.
> 
> Pavel Begunkov (2):
>   tests: add no-op executable for exec
>   tests: test timeout cancellation fails links

Don't seem to apply, fials on Makefile.. Care to resend on top of the
current tree?

-- 
Jens Axboe

