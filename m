Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA58819DE9A
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgDCTia (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 15:38:30 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36121 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgDCTia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 15:38:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id c23so4019345pgj.3
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 12:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sRNYyIeMzpysZVQ5Pzq7FfugQO+oXuiOuiGWgZ/frmk=;
        b=kT2oP3xqE8CUSK//gAiRjIJ25+b398ZFU56h8MAeXK46LQV4/AwY932WmgcJjmGfS1
         mzZRGJYtXqLU2JFhQxQoOKjivoYPGdNlk0BJ//1t+3fYbVVzjoV9cCHe2iLsXsp3Grii
         nsZ8v5asK00kUoEC80Zr4w1/tYCOH+7vzBd37YOu0bGdcXfzQDuD6GqyERX7rCAMWWS6
         1POgnYWoqBMXFfrGz+71OHpneDG/Ujee1EpuAT2WlpdGEqmmgHwqbCK4GA2VtAM9xCFL
         lmE3bAlfOFh0juI62iADam3RT+LXilR+ScgRsH68MF+kQbwgnXBVfowTIh3PUCt3+Ce6
         nmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sRNYyIeMzpysZVQ5Pzq7FfugQO+oXuiOuiGWgZ/frmk=;
        b=goEFbuRJiJ4yynIdfbekryfnjGNoaj74VarpPjnBRthioT0ZLRiDLmM2Ds8zJlYurf
         U5c7ZzSZ2wm3SEAnLfl5FW8sXv4WHWxL3eUTo/Us6F2x/o54QFH3Do4fbU0WJ1ZCz3t5
         Ytqz2p5fXHeF/mlfXNbmr6ZwhBgjS/F5sstx8etgAWUfInOj6AAmMz3Wbmu5w+HfI/Hk
         /etssuXEISpaiKGHwj8vhiCuSKuAT69ypSUl4jsbf3qv0VDnQ6LofRW6+a7rs2kn9xQY
         yhRsnCYps0/yu2iq+J1LlQmvqsQqI0DcC4lqJLb+8yRSHSMseoi8rEOsGpwrDdwgq1k6
         oyOA==
X-Gm-Message-State: AGi0PuaD6XuvYFOwxJV5Zj5jrYcnY9JXX0XEeUJNYa3aD7Y9Ecx+3bAy
        wm6hkfT0Q3N6PwJ57ibGSfhFxMSaXuoqWA==
X-Google-Smtp-Source: APiQypKynxIqVBTTbAL51X3NGg4R2Ccd3/Xb/zwKwuoZSKc+9Avw4qw3bu2vO3XbKLdxP9QBZc8OTA==
X-Received: by 2002:a65:670e:: with SMTP id u14mr10070735pgf.264.1585942708827;
        Fri, 03 Apr 2020 12:38:28 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::15af? ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id r9sm6039227pfg.2.2020.04.03.12.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 12:38:28 -0700 (PDT)
Subject: Re: [RFC 1/1] io_uring: process requests completed with -EAGAIN on
 poll list
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1585853665-8705-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1585853665-8705-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2565c157-1c82-b055-57ec-32d85a6f947b@kernel.dk>
Date:   Fri, 3 Apr 2020 13:38:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1585853665-8705-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/2/20 12:54 PM, Bijan Mottahedeh wrote:
> A request that completes with an -EAGAIN result after it has been added
> to the poll list, will not be removed from that list in io_do_iopoll()
> because the f_op->iopoll() will not succeed for that request.
> 
> Maintain a retryable local list similar to the done list, and explicity
> reissue requests with an -EAGAIN result.

I think this looks reasonable. You could make the loop here:

> +static void io_iopoll_queue(struct list_head *again)
> +{
> +	struct io_kiocb *req;
> +
> +	while (!list_empty(again)) {
> +		req = list_first_entry(again, struct io_kiocb, list);
> +		list_del(&req->list);
> +		refcount_inc(&req->refs);
> +		io_queue_async_work(req);
> +	}
> +}

be:
	do {
		req = list_first_entry(again, struct io_kiocb, list);
		list_del(&req->list);
		refcount_inc(&req->refs);
		io_queue_async_work(req);
	} while (!list_empty(again));

as you always enter with it non-empty, at least that eliminates one
check per list.

We could also issue inline again, instead of punting these async. But
probably not worth the bother.

-- 
Jens Axboe

