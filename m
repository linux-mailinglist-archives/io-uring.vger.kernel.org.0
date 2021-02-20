Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0A43203A3
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 05:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTESj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 23:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBTESj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 23:18:39 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B272FC061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 20:17:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e9so5384731pjj.0
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 20:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hj8WVLUU3jbn+eFLQ1QXJxM2bTW9J5Et2S8Xg9f/zqQ=;
        b=lEgR40Ai9hA2NnNH182lXPYch65FgHlbL//hz71BHrNzgMNqHzYNVRZhtPLw9LVN1f
         56c4s9nLTacaeTf16tqYyWPT1p3eYz3LsPMQ6MPyBwLmgavbFyvjFzRtS3YBrX+EiG+v
         9zXJbwt2mgpYl9ALVQ/sPn+YFPmBANYvTndEJJerCR/uYoZqOI4eVZBQtWkTvlGZZ+M3
         3JjjsUR7w1udBh1YhV472kxkAsumAIAV234SGEbJqVwf78KP/vM+XCeSKwayaiRkcF2+
         Na1Noz4k/iZAUrsyOFO2SiUIrRu/9hPQWOxulnttsTBJnJF0nSEVgtgi0WQINch6s1uv
         Px6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hj8WVLUU3jbn+eFLQ1QXJxM2bTW9J5Et2S8Xg9f/zqQ=;
        b=jVMW/bbb5NihM9I4mwoqzWJzYP4pwjxFE40YNAOLR29o9HZIh5wI7Uyly8gJhcT/cu
         4h2GtVrtfBbJPnpbyExwTT5DB3VIwK5ds3UKEta25FGX2ZWrlc3jD4zQpFt8aDypKbfG
         26zk8A1AuQ9DJVtAMdlcDu/3xaNjiVS/Ec6rm3JSAoWTppqjmBMD+/qGOJQ9mB3cEvKU
         zX/oAImtfgUXccSUiXY68Do1IXv0s1yfUiWxIiLTuAnO57KOWYh7pGl6r7MyZB0sgx5q
         WHRpCxx1qQH8Fz+IoKZ25Xy9cCBaDMT5t7jmbcpBSNsT1cpdkWXEEG5Z5LRX41o1uYcg
         yKQQ==
X-Gm-Message-State: AOAM532zYiXvnDHNgTcd643zt5DQifg2dE0HghpZeGKqamCHZN/LnIyT
        /cF4m9WgR2msaRG8AKgHdZPNgzNUIQCRMw==
X-Google-Smtp-Source: ABdhPJxwwsZ9U2UP1N8WPLgqpxg7zI0yjtMQ7YBKdDCFcx0ymH1BTWOIhkeGe8n8NsmOHwtLQhKctw==
X-Received: by 2002:a17:902:9b93:b029:e0:a40b:cbd7 with SMTP id y19-20020a1709029b93b02900e0a40bcbd7mr4923295plp.16.1613794677827;
        Fri, 19 Feb 2021 20:17:57 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h23sm11061839pfn.118.2021.02.19.20.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 20:17:57 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: fix leaving invalid req->flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613785076.git.asml.silence@gmail.com>
 <67c634daf96050926d32cf9c692e53b9144e6f79.1613785076.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08a87f71-3776-8554-6365-298437989c0a@kernel.dk>
Date:   Fri, 19 Feb 2021 21:17:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <67c634daf96050926d32cf9c692e53b9144e6f79.1613785076.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 6:39 PM, Pavel Begunkov wrote:
> sqe->flags are subset of req flags, so incorrectly copied may span into
> in-kernel flags and wreck havoc, e.g. by setting REQ_F_INFLIGHT.

Applied, thanks.

-- 
Jens Axboe

