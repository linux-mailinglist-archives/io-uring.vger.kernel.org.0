Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7987E1E2EDD
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390995AbgEZTcZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390822AbgEZTcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:32:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC62C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:32:23 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id i17so586957pli.13
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mPMBSEoFG86rRhFkn52ippvpiiEp7k8qBw0SEV6Hwgk=;
        b=aQdEXYgWnpFMIdZ08nHk9kPfqgbCMAss4Khem6x2kPel3ySPuXs9salp24OuZ41WyQ
         fy/vR17C00aDRAvoC8WucIRTchIRjt7yZ/j+f5o+LiQk+tNp5DOVzt9sM/YwzzbURIQz
         FE8lN9TD6Brz+iwZI0XWn1ZkXBxnucTstQIZbHOfrRN2V8TwjG4xlb8gmLBBl5haz63R
         5W3HqOfzUVxq7AV+rYEW+fYlmVYEqFGioKV5WSDgoUICH5TPlCMLiL17N6sB6gCcKBiu
         TAEN1opbo0YbMqX6l7DjDw8BlsZdfjE8dji6pvKUeMJncgplbIsETcJLCMa11ct3Iawv
         7EUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mPMBSEoFG86rRhFkn52ippvpiiEp7k8qBw0SEV6Hwgk=;
        b=l61rOV8C0BJgzetzUUh95lUAZEzBDzQW/AygQYqs4shprS+XYO/6hf0Qc8nhd689qG
         T+d4xUKiTyCHLg8wY3qOB5KxUi+mQQwvbRp40KJMmPDxTrn8KXeaiyYcas6sFhdF5JTa
         /9drMOvJDHwXDHN3GH0fDvZDuXT9StxyLqTw9jLHsoElHl1SWYp36p/gqFCc0+au0g1Q
         E8v7oiE8DQJ9mA4PoO61V8dAOnfXD1ga6fe4Lk9C2Q5Et/FqghH2zuknzYQmscviO+TU
         WiaA0phMZPeSkZwamxDihfinGcMNb2vLrlLa/l42ndJeZ2De9eT24ZjBX8K9SO50ttL8
         y8mw==
X-Gm-Message-State: AOAM5310DqaOCRsAi7aw9fGYnprJNcWHgZq1vMlxKhpFXTIp+aZmpMbm
        z0PKJ9hZOMO1hx9bNg78wdBS2w==
X-Google-Smtp-Source: ABdhPJz1+9mdYhlnOaOdqKsnmVPgb0+czO05jZqAokJjqgkvwtR2WA5G3WY3OLtL0JaaXWVfZ60U6g==
X-Received: by 2002:a17:902:8d87:: with SMTP id v7mr2444717plo.153.1590521543229;
        Tue, 26 May 2020 12:32:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:94bb:59d2:caf6:70e1? ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id y138sm310164pfb.33.2020.05.26.12.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 12:32:22 -0700 (PDT)
Subject: Re: [PATCH 0/6] random patches for 5.8
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1590513806.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff8f6fa6-e05a-5ac9-1d77-a8a96ca823db@kernel.dk>
Date:   Tue, 26 May 2020 13:32:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/20 11:34 AM, Pavel Begunkov wrote:
> Nothing insteresting in particular, just start flushing stashed patches.
> Ones in this series are pretty easy and short.
> 
> Pavel Begunkov (6):
>   io_uring: fix flush req->refs underflow
>   io_uring: simplify io_timeout locking
>   io_uring: don't re-read sqe->off in timeout_prep()
>   io_uring: separate DRAIN flushing into a cold path
>   io_uring: get rid of manual punting in io_close
>   io_uring: let io_req_aux_free() handle fixed files
> 
>  fs/io_uring.c | 64 ++++++++++++++++++++-------------------------------
>  1 file changed, 25 insertions(+), 39 deletions(-)

Applied 1-5, thanks.

-- 
Jens Axboe

