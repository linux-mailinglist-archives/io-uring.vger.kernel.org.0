Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4414A1E728F
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 04:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404458AbgE2CZ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 22:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404312AbgE2CZz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 22:25:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEF1C08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 19:25:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bh7so399599plb.11
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 19:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xn/z9OwX9EDVD9GQWF67aL2ujFBcaUqJnV0rIOGCsIw=;
        b=fLnyi7gpUbGCUK4s6UIEhMlKfItl8kS0dAEsFcTTkGJ9IBqXQ0AHzWZ10JZvbAIIkn
         hhVgyPjp71Fw4hVJ3Y9PwolDCkgxpUkCs9c+S06zdjc9lrOqLgSj+ZryCqXs8rNJb40A
         gLfabIXkKjUExZq+liYF22NsUk/T/TiU4r61yBeKB1k+UJCqQxwWSth2z7dLc91nd47R
         WhmzDpSKjpGzv3uiPnU3ebs5HYLNeBq2fvXB6IB8JZng6YMmoIgMe6F75UYEZ675YEXY
         8zQMcVpPhki/A2lcwlGYip8kTIynuSWhvwe5q6GV5zfes8hiFjfXFT7HkBrQp/toCqhp
         DF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xn/z9OwX9EDVD9GQWF67aL2ujFBcaUqJnV0rIOGCsIw=;
        b=DnrPI7w6UKhnZzf5UCkTuXOaArNmPnateIwdvq/PydS7KFZ5Hci4oEEHPLfmhupKua
         jHZcHLC2TLrYNDzlaS9l++KFvbkmob9PDGZirz5J9kVg+DK+ty6RZtYOkMcKWAs3QEKZ
         Xchm4DRf7zFwIIrXY6DkecIVVEKAG4+v4u0wi6k4D7FhP+eMPKJuAnhIquMn6Ifht4Zl
         NDA6JY8tSUpF8mfHnnGnIZhP0IdzjYVOs28bHs4UXrF5QcFSXLeTusufIH3ZoTVDPm9C
         7wTJc9s80+X+pvrs3L9rg5t2FRn2ESuf1D7gVTrTkAhNQI1q3EZU5OArqNS+oPE1Xwka
         QwWQ==
X-Gm-Message-State: AOAM533LqemotpBPMJc3hu1hYt1TL+an7AvK8NwI5HHp6tM48BSfpbDD
        osswZHdZucgG85KR9NDVwVCvpJWRYBHLGQ==
X-Google-Smtp-Source: ABdhPJyvuvTnFbXxnGDeS/JYzu/FZzriG9yoPnDGpFjYpVxjq6COv1JPYKzuxNe0tTMQPKaKfAJliA==
X-Received: by 2002:a17:902:7602:: with SMTP id k2mr6174187pll.296.1590719154333;
        Thu, 28 May 2020 19:25:54 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c123sm5747578pfb.102.2020.05.28.19.25.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 19:25:53 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix readiness race with poll based retry
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <42bd1541-00a5-430d-2a47-706dcd2b57aa@kernel.dk>
Message-ID: <226aa908-d64e-8970-3a90-58fa5a45aab5@kernel.dk>
Date:   Thu, 28 May 2020 20:25:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <42bd1541-00a5-430d-2a47-706dcd2b57aa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 7:51 PM, Jens Axboe wrote:
> The poll based retry handler uses the same logic as the normal poll
> requests, but the latter triggers a completion if we hit the slim
> race of:
> 
> 1a) data/space isn't available
> 2a) data/space becomes available
> 1b) arm poll handler (returns success, callback not armed)
> 
> This isn't the case for the task_work based retry, where we need to
> take action if the event triggered in the short time between trying
> and arming the poll handler.
> 
> Catch this case in __io_arm_poll_handler(), and queue the task_work
> upfront instead of depending on the waitq handler triggering it. The
> latter isn't armed at this point.

Disregard this one, I don't think this race exists. If we hit the
poll->head != NULL case, then we definitely added the waitq. And if
the list is empty once we're under the lock, we already triggered
the callback and queued the task_work.

-- 
Jens Axboe

