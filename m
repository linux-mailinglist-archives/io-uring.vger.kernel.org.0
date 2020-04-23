Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEF11B5EC4
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgDWPL4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728928AbgDWPL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 11:11:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD4BC08E934
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:11:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p10so6713313ioh.7
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YnYshfoH/ql1B19ispyeNmSbWJt2LFcxfoe/1Q9e39U=;
        b=EAzhakmpm0SYe53qstC50PrizXLpCEjwN51UxoLhFHM26GploNyELmttjCmDsfDImc
         oi4FMxvEQCrRyZTa0ApmzVNy/qhwHtrgzlnpHkD+G4x0Waz/hdTG5GyK9ja0Yy9D7I06
         EeZm8mCMoYU2bmDkoclssHZqO6vCc93QuKIptOypbpo+PIwNfIK3vq8oI78iS5qz/Ere
         v7I8U1CoHftiT4CdFF5Xeq3XL69KNmeCtomQI7XewQFwP5ObRI2YjgoTXYED3qhfjpH+
         wFFkc1zsg+MYEKBWiGD6EHCQmdEsyn5U9GVs6iMKGSX8lGxJd41djXxqnlB3RdFbQHNF
         NWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YnYshfoH/ql1B19ispyeNmSbWJt2LFcxfoe/1Q9e39U=;
        b=Vq4tok/aB37TTqN4ayJWGM2px8EEhs9hIyysxTav9SWVM3gGZdxRVQi123nByk+SWn
         gPVTLipHru4ZtxRPz38gHZSQP5gyplHKoLKEPKYjTdPEtGkdmOz2O3m5Qo9ZIMRIVzci
         WdCummYBOiTAAfnogV99zNMu8Z1KE24lUZ9p+DMLy796l5ulZDaZFOSaFjXATydATnnd
         EOigWynOH3KAb/gJHDUTl+uHL5T+uo/zjPqp2RzMZqNxp63wv7CRjz2WoTm0oh7VrKqO
         xiOC9jS4xpIGPaAoojwAP5QlYMg9bIO/QtT+AgheJFo8Kuak0++fCQpUMgHy1O0+6lRY
         tUoQ==
X-Gm-Message-State: AGi0PuYlzT7QsOu6G4/ED5u2tYlBQQ4q5Sj6Ji1y7tUVR/qb/eovBy4G
        Hx9W77aIWQW5uW5HocuSkNLIZS53PIYQAw==
X-Google-Smtp-Source: APiQypKeE4wG3nGqK3b+UFei2SBURsQQFhx5ey+Bmu15vkw7NW4rDzsNAAcVMs2IBkspuUcxeliH+g==
X-Received: by 2002:a02:ccad:: with SMTP id t13mr3778353jap.64.1587654714786;
        Thu, 23 Apr 2020 08:11:54 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o19sm978618ild.42.2020.04.23.08.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:11:54 -0700 (PDT)
Subject: Re: Multiple mmap/mprotect/munmap operations in a batch?
To:     Josh Triplett <josh@joshtriplett.org>, io-uring@vger.kernel.org
References: <20200423081918.GA172719@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <99e94e7d-fbb6-1a73-e03b-e8b4a15d886e@kernel.dk>
Date:   Thu, 23 Apr 2020 09:11:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423081918.GA172719@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/20 2:19 AM, Josh Triplett wrote:
> What would it take for io_uring to support mmap, mprotect, and munmap
> operations?

Not very much, wiring up something like madvise as an example:

https://git.kernel.dk/cgit/linux-block/commit/?id=c1ca757bd6f4632c510714631ddcc2d13030fe1e

> What would it take to process a batch of such operations efficiently
> without repeatedly poking mmap_sem and such?

Probably just a bit of refactoring, to enable calling the needed helpers
with the mmap_sem already held.

-- 
Jens Axboe

