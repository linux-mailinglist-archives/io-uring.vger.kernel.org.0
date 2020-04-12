Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4068A1A5BF4
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 04:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDLCHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 22:07:44 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:43435 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDLCHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 22:07:44 -0400
Received: by mail-pl1-f179.google.com with SMTP id z6so2119790plk.10
        for <io-uring@vger.kernel.org>; Sat, 11 Apr 2020 19:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MJkeVaCjtJEc3yNw921FlHG88krDP9fP/xlRD6YHEgI=;
        b=xuINY7C+MXIl42ypNiwBGJVta6Zd2g1HMsHMKIl4bk9drYEfpY9odLtKZ0PvWRi5UJ
         qwH+vsnO4JsQzQveVtzdp8noNR5wQbs5FFnGzZspnPCQ4YkASXR9UNH6nBfAjSKTAFjh
         HmSWIlwP6HtcDyCYAZfb4OW+4eXlW2wi5wekq57WSOgko8E45Mv2btaWuF4Y5sc4GEnM
         9KGGjM3bUkta12jq6IS8qFfM0acPqcSi5GwkLS4897m2QgXhOpFR2wqPMDqHNcd43X+9
         g+ci4kx4/TEhMY6YIBJNhJ+c3um3aNiyzedVO82Uh6WqRLC/Fr5dCU/Q7mgbTxHObtk5
         fJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MJkeVaCjtJEc3yNw921FlHG88krDP9fP/xlRD6YHEgI=;
        b=C5KUzs2t5s/d4Q7zrp6XovSEANccQjFOVNyAICN4L9OJJDHKoGybNJWsCrbhg1YiNh
         SUgXx6tI/hCa1j1ORKRk0Cd1oIt25sI29UWlEDSDwWLWwHc9659Om7H2K+Hmm5oPStHg
         YAh4XTusOL0fzgRKjjw69e6aX9qMfoKE6SnfOTF/FJjOwkVsF4rSMMqtxcPkKAwTs4W4
         b/w39QXY/WJqAvuvzwWyclIv7DhE1PoUlYIiGh2SDjLTqNCRejKhPM4S5fTDC+jNtBKb
         htl+osYM+VmepADWS3CY2Nj3dcPn11ViVPHqbt7+pwsJjuB1xfoATiSD0+gkANS0dJ0P
         BjDA==
X-Gm-Message-State: AGi0PuZQLRPi5Y5ZYvopCUstVIM5W188dw8xQVKoEOIaZkDc2pMjoPYC
        Ns3cbMlTB8IrV7R94Ch/yemQvA==
X-Google-Smtp-Source: APiQypLWV82UyC+m1c6rdDcXZVPNIZHo/sNDh7vxcs2xHYU5DWCXLxlujw0msB61IiXnNnysCnb8bg==
X-Received: by 2002:a17:90a:1a10:: with SMTP id 16mr14582853pjk.31.1586657263340;
        Sat, 11 Apr 2020 19:07:43 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u26sm4678379pga.3.2020.04.11.19.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 19:07:42 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
Date:   Sat, 11 Apr 2020 20:07:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
> Hi,
> 
> I've been looking at timeouts and found a case I can't wrap my head around.
> 
> Basically, If you submit OPs in a certain order, timeout fires before
> time elapses where I wouldn't expect it to. The order is as follows:
> 
> poll(listen_socket, POLLIN) <- this never fires
> nop(async)
> timeout(1s, count=X)
> 
> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
> not fire (at least not immediately). This is expected apart from maybe
> setting X=1 which would potentially allow the timeout to fire if nop
> executes after the timeout is setup.
> 
> If you set it to 0xffffffff, it will always fire (at least on my
> machine). Test program I'm using is attached.
> 
> The funny thing is that, if you remove the poll, timeout will not fire.
> 
> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
> 
> Could anybody shine a bit of light here?

Thinking about this, I think the mistake here is using the SQ side for
the timeouts. Let's say you queue up N requests that are waiting, like
the poll. Then you arm a timeout, it'll now be at N + count before it
fires. We really should be using the CQ side for the timeouts.

Adding Pavel and Yi Zhang.

-- 
Jens Axboe

