Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61293F9E92
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 20:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhH0SMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 14:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhH0SMv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 14:12:51 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8B3C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:12:02 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j15so7885868ila.1
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8c5wo0R7xTCIvOsDcZKfKFq0xxoUQfLY99AI1gLIqZ8=;
        b=07xpfPCeK5E+jGaLyVQUbT35WfeBCKG6N8Nkw1niBFLAnAsGZYsVkx3UiJJLDFT4dt
         aEW5P+RWPMCqwYs2fu/h4wYwefslFNAp714IJc4LoosmoVNenPD+gIA7qIADkwa0X5YX
         r+f/LrXSChWaiEgzPK64HaHH6X6pHNDZ7zoo6s/IMpJ2ZzeGbb8KekkekuuPeO8+c+yC
         CfEgM83Xxyw0biQ+g/qszO7EUD2B7AK31zHOG80HS9IdbmXJT11FUZ74LNVPqVmyjHUu
         Ns2luuf86UfbalUfny1k7YReCojJVmBclVH7gGb/9BzCQMGgsTXMpfWBtEDPIsOj+Jze
         Fqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8c5wo0R7xTCIvOsDcZKfKFq0xxoUQfLY99AI1gLIqZ8=;
        b=oNlHZNvhyqU4D3TJTEi73iTfF8EmFV8WffTUUrwvOUydScCIjj//ZVbcLf3NkIBDKj
         soWCfRQGxX/CM8j3A2cMIojZKegv6fLn24LObCBcSKktynba5LRPy057LkWqtQ3TbUkC
         749TuhSX5NjGjzck7s+2aZzXwKld4ewQk4CxuLO3rGCNaQsgqtDHvb1Uz6d+jcSpldj0
         VHPJgOQo0ts5adOduZp5Kh9Jzcg0wx49hDpYt3yNjJytxllGyW9YcH7Qipks3ZgZwgLe
         aUMGOgoY9KUe8KvHahwWUZq8RMJRGcvCGFsvfzvY26WXknrv2a3/zxfIeaYQOEjcQR/l
         SAdg==
X-Gm-Message-State: AOAM532152MHq0wKKyDlszZpCXMnhZ0uX/SvZy6TNQ454vYzqg1N0HLp
        oaT1SDWH9eiEYN+Fbz0etqsAjG7W9bgsGQ==
X-Google-Smtp-Source: ABdhPJzJjOG2T6qoXMBoxnwm5ayp99Uzb6hA7EfKTLg6qTDQLqIHUD2KtabRtbhPDSWOAMY308mHhQ==
X-Received: by 2002:a92:da11:: with SMTP id z17mr7525875ilm.176.1630087921923;
        Fri, 27 Aug 2021 11:12:01 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h25sm3408771ila.78.2021.08.27.11.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 11:12:01 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: file create/unlink cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <abbcfa9fa56fde7e740a2c887afef74a779bf36f.1630082134.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4328a2dd-a29f-eed7-af37-4ba2532658d3@kernel.dk>
Date:   Fri, 27 Aug 2021 12:12:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <abbcfa9fa56fde7e740a2c887afef74a779bf36f.1630082134.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 10:38 AM, Pavel Begunkov wrote:
> Unlink earlier if possible right after getting an fd, so tests don't
> leave files when exited abnormally. Also, improve test file naming in a
> couple of cases.

Applied, thanks.

-- 
Jens Axboe

