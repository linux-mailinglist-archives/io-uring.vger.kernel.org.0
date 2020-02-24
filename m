Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7112016AA36
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgBXPfz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:35:55 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38314 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXPfz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:35:55 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so10671658iog.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zddawmptTj8O/iOFAeDEIVRJudMFVZUKfFGPqjx1LMk=;
        b=NLvGifZF6nw+IxiFIhrBLRrajvZsnwn1tkIxXaXebNAqQHMSuIBDN2uVpU6oYpef8H
         YcAsxc1k6I4XLVgnP/rr3t6/nGF8DUpFgf0RBC3eDBl1skBwR2b+XcQNzsmb9DkMPk/h
         kTQZaRz76MdM/7+E9AgkSMHFh1DMeJCljGydy2AB6sd75EozDgzhpGd4fszRSu6MkPoH
         d3qbbRezx8I+B8ILIZtOYrllU3XNFtpUiBsIMaZckU4xZ1qaE0AW6VKNpzPzKEyWnE9c
         O9s3ovM1lZjclsudzHwkv1PmmFUUwFjX24yERfq0Bn0s9xZhQkYW4EVxMMsan6OxCF3y
         tHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zddawmptTj8O/iOFAeDEIVRJudMFVZUKfFGPqjx1LMk=;
        b=e5hERJWeuAN0OqHtrEvBqhXopCITOh4nGJc6qdt5ABCaMykt09nyyWga6wLKP17ouR
         cSdFakIWXR/pu0Gal/gmw2ntd3FWltT+Zcf8P09fODqfCdnDkFoF2kB1LaThL7Pc/VJ8
         elJnwS8ZZ0nfa792lbdbdLdLRCqepnyx6IqO2+oMeSKvDuB3kJf2l34OqjgbuzlYnpSO
         MoUGm5+IOASouFyoyM1mr97wekCdp5JXlE4yWbm18DgBRVAxh/iB0AxQKIMvxfoXHHiM
         PMs6djKYoZJbAI0N06+yxEo0LHjXiP21Ne7XZbS06jwi9nDuxSdi7zZKh5JwOQetAPe/
         74cQ==
X-Gm-Message-State: APjAAAVVOx6GKbRDvtPz+rClt18HBijKTz+7MgOB+rqtI/tIU+Fv2vWh
        dEovoQb7Pg7Dr2+leh56IMjOEwLLBCA=
X-Google-Smtp-Source: APXvYqxJLYN7KxGZRPJQFZnCFWyWjTrI95KeI9Mk/yjMubZC8gJzK/dCmDDDpmGRE3GeVaB1yZIXeA==
X-Received: by 2002:a6b:6604:: with SMTP id a4mr54584788ioc.300.1582558554596;
        Mon, 24 Feb 2020 07:35:54 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v5sm4426550ilg.73.2020.02.24.07.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:35:53 -0800 (PST)
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1582530525.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
Date:   Mon, 24 Feb 2020 08:35:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1582530525.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 1:32 AM, Pavel Begunkov wrote:
> *on top of for-5.6 + async patches*
> 
> Not the fastets implementation, but I'd need to stir up/duplicate
> splice.c bits to do it more efficiently.
> 
> note: rebase on top of the recent inflight patchset.

Let's get this queued up, looks good to go to me. Do you have a few
liburing test cases we can add for this?

-- 
Jens Axboe

