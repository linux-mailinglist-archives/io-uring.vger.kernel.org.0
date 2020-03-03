Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9C178503
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 22:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgCCVlC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 16:41:02 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45724 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCVlC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 16:41:02 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so36724iln.12
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 13:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=y4BPnxRjRQmS41LUIF2L8mvdJaQq8+rrTlVY/f5XiEc=;
        b=v3UGVgXO+XIpk/RYGqz2XOIeyrfSrbnFNb9TIn/u460b9GU5xjCXpNNKqoq3KM/Dlo
         V6Tk9KoPqlFFwKRW+N7qc7QkhtBC52tQ7sI1w9GH2l4pgyvGPimZVfmt9oK3/flxQpUr
         X7blkTF5huerdFeEP3wFVUMFF1Qsi6hW6IMudzuNsfEvVdCdXUvul9pqk31pJwlLEnt0
         FEol1F4L4tXVSx6R+wXk/8PlGGNRVwNB016u1zfsIYoOoxKjKJWuX7TI4JnuaTqk3QxN
         EmwEx6AJ0kOzS/uzkZ/P91c5q18VLw4h8bt+yxROnLW2pbJylrim4vYTMvye5x+MDJNF
         pZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y4BPnxRjRQmS41LUIF2L8mvdJaQq8+rrTlVY/f5XiEc=;
        b=IcngVwWV2XRouX2/9ThOcevK95GKJKqAqt+Q4xwoxrK22FSVq7V6GaIWf9aVxNGJsy
         N/0x3es7sbSS8zAJ0oiplTrVUl/U83rpd+yH1BEXaxT3V290JqA3ir0oaS4PucjQ+wmN
         RbyqzF3guukMwuxKDVsJIhQtqzrfsxaj+/MQUzuQr7YdCioZnKKV2ncat/Ipa6x7jZt2
         BhfPZoDhSF/823h4SnfolLo7765OvKYxmrKClAATGLpskY7WiXzUxvLog2c/ONH9GBlq
         9idviwSIx/zFEZ0tW2YHaTM9uVCR1nil+LfHDwD511IeWbsg/zsp/jEsHJZ4jqIKrTWF
         Dn4w==
X-Gm-Message-State: ANhLgQ0LsZnSl5KREQQrk8fKM4jq41jK+isj6JVEkEaHMcpYVexb8+co
        dosJB+1B8Ndgp3xWpDam3jI+vvTS6y8=
X-Google-Smtp-Source: ADFU+vverQRhyfdXUIFxYIWwnNQizQ3NTtNKyaot0sVVumwOpesyCX7k8yUBXtJHswh9tOyOXDSX9w==
X-Received: by 2002:a92:3b4e:: with SMTP id i75mr6552306ila.20.1583271661845;
        Tue, 03 Mar 2020 13:41:01 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g13sm1207469ioq.87.2020.03.03.13.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 13:41:01 -0800 (PST)
Subject: Re: [PATCH v3 0/3] next work propagation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1583258348.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <37a34bf9-e599-8bf9-2a7b-3c2bda9d3e8e@kernel.dk>
Date:   Tue, 3 Mar 2020 14:40:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1583258348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/20 11:33 AM, Pavel Begunkov wrote:
> The next propagation bits are done similarly as it was before, but
> - nxt stealing is now at top-level, but not hidden in handlers
> - ensure there is no with REQ_F_DONT_STEAL_NEXT
> 
> v2:
> - fix race cond in io_put_req_submission()
> - don't REQ_F_DONT_STEAL_NEXT for sync poll_add
> 
> v3: [patch 3/3] only
> - drop DONT_STEAL approach, and just check for refcount==1
> 
> Pavel Begunkov (3):
>   io_uring: make submission ref putting consistent
>   io_uring: remove @nxt from handlers
>   io_uring: get next work with submission ref drop
> 
>  fs/io_uring.c | 307 +++++++++++++++++++++++---------------------------
>  1 file changed, 140 insertions(+), 167 deletions(-)

Applied, thanks.

-- 
Jens Axboe

