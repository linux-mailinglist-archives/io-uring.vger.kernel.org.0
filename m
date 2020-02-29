Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D37174975
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 21:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgB2Uz5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 15:55:57 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44700 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgB2Uz5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 15:55:57 -0500
Received: by mail-pl1-f194.google.com with SMTP id d9so2611958plo.11
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 12:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NUOQWtXrLqCzsr0Qrm3PTxXVOmbf/Tqg5MQT7aINH/g=;
        b=DQO95RbAXcxBOoIv+87KHdVtXA4+NpRQcqut2b1pdKydJxjGQNSwkSlhcUs/T43oIb
         HpDPX04ChmWT6Su+zIvLPgmO69wcqVPESV8CUTh3GWzcTG/AsIzCLmToA2t1QqafVftC
         Mf2Fw3KtfmXupq1u0zXkxZFid4Xc3WuscHnn45aYqFdeqiqEM8lcr2rTp3bNoXaf2/46
         5vKyZGUwmpiboT+OIiFv/HWaWUvTSZWbfW1e0eWZBTyNYgSM+7XFIgMcktZO4Ee4Yfn0
         LGVQcmRYy8MwauWkgAJMQ8T/gVN20faZO3KmLZrA/oXw4xahVfz59znbsXmzcg3b9FAO
         9QVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUOQWtXrLqCzsr0Qrm3PTxXVOmbf/Tqg5MQT7aINH/g=;
        b=sAC//h4q6MzowBwTskcz6sY+eBhZvoaP0I8sUBabCRd0RFie/7paHdD32zSa6LfpHN
         9fCoVo6S+tKc7X9ZUE1aCqReU6Acy82PZ9mFmgy4yYJzwKRl3W6+UwQt/ibWVuee3xOq
         bIeF0ki+rxaKtJx2AFPOTV5jUfDmqs4oFK6z9S16AE2MGgTanrG0NciF+UEZ7hBkNuCA
         FYgsHQsxe0aOU5U3Tre6vQjKtXVUs1FZ3fcVU6D3Uth1cDDYUxXNh/sEWJAYgZCIQ/SE
         PW+ibHcFBBqO85V8h8bG06e90FLSoBgkbHPG56Y0LPOkxMP84YyE+NN0WKMY88+XMYxJ
         SmgQ==
X-Gm-Message-State: ANhLgQ1+yBKpT7A7pPvBBbgRrEia9B+eQFIaDP+zKxhfax1DhOfUQnCg
        J2zze4gh1EoymDTvc5XhO5zRVw==
X-Google-Smtp-Source: ADFU+vtnidGvovu0mQB7x1rQWGUAmmnF18IESC89APPM/k4hR0iTkw2I2i7syLtz30OehBbgxi1V2A==
X-Received: by 2002:a17:902:7c04:: with SMTP id x4mr2856157pll.4.1583009755204;
        Sat, 29 Feb 2020 12:55:55 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i2sm6472969pjs.21.2020.02.29.12.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 12:55:54 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: remove io_prep_next_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d5893319c019695321a357cb1f09e76ed40715d1.1583005556.git.asml.silence@gmail.com>
 <b97698208e565be70ae0afae1851e0964260c3f8.1583006078.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4d9c6f63-4031-e622-b44f-8d5bfad232dd@kernel.dk>
Date:   Sat, 29 Feb 2020 13:55:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b97698208e565be70ae0afae1851e0964260c3f8.1583006078.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 12:56 PM, Pavel Begunkov wrote:
> io-wq cares about IO_WQ_WORK_UNBOUND flag only while enqueueing, so
> it's useless setting it for a next req of a link. Thus, removed it
> from io_prep_linked_timeout(), and inline the function.

Applied, thanks.

-- 
Jens Axboe

