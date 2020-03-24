Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6F8190393
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2020 03:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCXCbk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 22:31:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40841 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgCXCbk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 22:31:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so6770383plk.7
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 19:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ayvl5ZRVP8urDgR+Ya++oM4Sz7bhwsqPOecJQB4bPLY=;
        b=WZFLJia9DbEO7xA7AqQeVnc+3cg2qtxpTjJQrdRzYrOUA0wTMQPSxe1LjpF+vmiQf7
         BA/jR/fxjKXdbrpsp2HkPbmACNodSsq7cwNNlemEW323pUzWlbt0tDsXUNyBYfbTKGzv
         8ttqstJV5yGLSpd4vZW6FHSKoxFxDdbV1jwLXqZI+YjH0rXg4yzOk3cryorGfHsezcDR
         ALpzzGZAZ7oE1lIZ6b3E0/fAfnV+9ickiR03+uep97ndFmqK1hVaJ31wGJ7RQIot959O
         arH8UoY+1AEdsl6i3pNv7aTqz49O7Sg3SBAOO3gFaE5f2RIFd+aIh2Z958o8H1gBUo1m
         09jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayvl5ZRVP8urDgR+Ya++oM4Sz7bhwsqPOecJQB4bPLY=;
        b=iUFkkoN6iLZVg6VzQAoiQhQKEyDFZ36sj0LpyDfnwzA3qrrlkmEt37PZLFqUVT8Krk
         Ol0p2E6jhQCW+6TNXzMjZTDpQbZXEcFI29wh8VPL/snF10iZrcDDyhI37UhJqkEfykM9
         TGBkfg7bNWwTOZ3kA17dJjhgYlXU+V0amrDfc9IFgOhKT1M6qdnQ3ilx4ORrCVHiK3+t
         cuRhDqE9tAIBwgNAf/LBCi2vj+3q5Kt6/iE/lwI/p80YgsTHOeOweGLxZfjBQqrRi/RW
         Ewb5DnUuoJJAUsNwVZVWYTjFuQxUpnbjGN7Z3lCfNf1wlHg9CjEtOzyVVWI7ZOZLkidA
         qvWw==
X-Gm-Message-State: ANhLgQ1iHFzVQo95RIDnq5qKjC1TLRnONFdBfOotOzSusNC1wRFP/9EH
        QaaQ8/9bcV48OHMZIVnjV/BD0viglFMwww==
X-Google-Smtp-Source: ADFU+vsmG/+gEDl7oOYTZcJEuONdHbVNCJN+lDjCboracD8ocAtjTreBwLtreFvTm+Eru1FAbVpkwg==
X-Received: by 2002:a17:90b:1257:: with SMTP id gx23mr2650574pjb.14.1585017098683;
        Mon, 23 Mar 2020 19:31:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x75sm14916302pfc.161.2020.03.23.19.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 19:31:38 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c0e464556675bd40ea47d61ce12e2393603ce43c.1584993396.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <637ca8a0-d116-dbea-5949-2462502df4bb@kernel.dk>
Date:   Mon, 23 Mar 2020 20:31:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c0e464556675bd40ea47d61ce12e2393603ce43c.1584993396.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/20 1:57 PM, Pavel Begunkov wrote:
> We always punt async buffered writes to an io-wq helper, as the core
> kernel does not have IOCB_NOWAIT support for that. Most buffered async
> writes complete very quickly, as it's just a copy operation. This means
> that doing multiple locking roundtrips on the shared wqe lock for each
> buffered write is wasteful. Additionally, buffered writes are hashed
> work items, which means that any buffered write to a given file is
> serialized.
> 
> Keep identicaly hashed work items contiguously in @wqe->work_list, and
> track a tail for each hash bucket. On dequeue of a hashed item, splice
> all of the same hash in one go using the tracked tail. Until the batch
> is done, the caller doesn't have to synchronize with the wqe or worker
> locks again.

Looks good to me, and also passes testing. I've applied this for 5.7.
Next we can start looking into cases where it'd be an improvement
to kick off another worker. Say if we still have work after grabbing
a chain, would probably not be a bad idea.

-- 
Jens Axboe

