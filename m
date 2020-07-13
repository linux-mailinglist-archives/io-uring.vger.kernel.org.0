Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1321E1E0
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGMVJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgGMVJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:09:31 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21A9C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:09:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so15074254iof.6
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HhM8dC9kj4ZOktxI0B+N+OGmGJKxZTsWApDyJkX6Mjk=;
        b=rstChivOOP6xuTufJEud3LAGu0cJ4WUWVIK+a21FwYiaX54E0wuQ86+8qPYzEWVmJf
         KOmJpBrOXoTDyyUilt26hpOU1UTiIjULRbo9/c5iujvbAAtRCxJtY5NldJETj+YlXerX
         CcJFQbR74+gEZsq4DPyYC7lx/453GacjpDYAJGUPgC7uKxJdhAiBpoUcisn2FjUjxVQv
         LKZapPBJlzeYGb4Wy7HFRFA+q4xt5ciGeN76nDaDtaYs0flobbK775mhhPjvKBqn0Y/E
         iw0bO9e7eEWNxRB+9WVQ8L2kYZy5ltNF1lhmWpfksIRzqLasRmReLGsp4LPTKhTSX4Ri
         kURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HhM8dC9kj4ZOktxI0B+N+OGmGJKxZTsWApDyJkX6Mjk=;
        b=O7D40uGY2A33/pEhZ3dk4jByG6yNUiPFur7zpRy+mO4TaU3DuK83DLI3HU9wjw14Tz
         TE7o/pCsTOpbr2hdWOcX1x2qG5TmvE538pnytM187LlzRfny+PgjNXN++zrbHXjyCWz9
         zzsdJB9std+pJ8kbqovLqgzf7CvxNjREZgcGvUpksaCBwkeHT0jTCgcU2LtkLDqhmhHY
         sQsTB3d/QLnzevHFz8gZqlT//9AHsRPHDv9aXw91HbPVUg2TcUasCCFbvisKJrphkm13
         FCjU5khikWi0D9tTrVDwEYFjwRzTRonaBPtL5CNmRMS4iMB0i/sXjF1J0Wh9pOyLjntg
         11zw==
X-Gm-Message-State: AOAM531czZuEXMT8hq/EoGQrSKRB1aj4Rdba16OLpPHO63ZilrZa55q4
        +6jQdcl0guUXWII9HpPfFh+qWkMZnTU9iw==
X-Google-Smtp-Source: ABdhPJwxz1inYkSMV1fq+iBBmB3SGRqEoeXqgHvPS1Pq3qFurg8L9PV/y00NpUkbvYY3VKL5Pu5NHw==
X-Received: by 2002:a02:c043:: with SMTP id u3mr2263387jam.39.1594674569813;
        Mon, 13 Jul 2020 14:09:29 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u3sm8051336iol.41.2020.07.13.14.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:09:29 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: follow **iovec idiom in io_import_iovec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594669730.git.asml.silence@gmail.com>
 <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3ac43ac-be8c-2812-1008-6a66542a2592@kernel.dk>
Date:   Mon, 13 Jul 2020 15:09:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 1:59 PM, Pavel Begunkov wrote:
> @@ -3040,8 +3040,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  		}
>  	}
>  out_free:
> -	if (!(req->flags & REQ_F_NEED_CLEANUP))
> -		kfree(iovec);
> +	kfree(iovec);
>  	return ret;
>  }

Faster to do:

if (iovec)
	kfree(iovec)

to avoid a stupid call. Kind of crazy, but I just verified with this one
as well that it's worth about 1.3% CPU in my stress test.

Apart from that, looks good, I just folded in that change.

-- 
Jens Axboe

