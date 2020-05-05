Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E61C59D9
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgEEOlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 10:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729060AbgEEOlP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 10:41:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF522C061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 07:41:13 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 19so2160236ioz.10
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 07:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EAGmUzWxZoZLwE25lpmmio1Fa3Jd51sh1L9LT/0DO90=;
        b=p4KFIGHLgX7AQRbZ/yzRF1EqhuRGE6z9K4h3uFPfEcmnhnIfXt/0+YwtIWxxLRAsBb
         1cd4ay4R1t/nVuyK0IvXAzCBjOq/TRLLOz9rikqM8mkiwwQk1QshpjiztUL9EFJplVLN
         l6+KOqpm/xhwb73D6Glmn+W74Kzxqp5njpiJ7ca39Diw+aEz853gQGa+iyoyFp5AwcUm
         KP8gMYei7CnNz1Z6VrO4JlqIRtbkalGaXENtLoy5NOD7pGs2TLFzmNnd047QqTldjr9j
         MaSSFNknSJ5F2TbbKRVcSjV7BA+LFctg5mT2ru6rFW984IfOXx+yRS6fzqz0GcFcYGVm
         N1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EAGmUzWxZoZLwE25lpmmio1Fa3Jd51sh1L9LT/0DO90=;
        b=YJYOizRRWUxp3pFo1Lh6E58WkLRXe8KAYvWEhdfulRrK20xZiRSC0nVHc9jHw3jc6/
         LsgQxHlTCuWzdec/JaaIxCFQnGGpFSirScUPsURKwskZfd8uNg8vkJl3KQqsLQaPhCpX
         U1ub3Eg6WD6R6bhEeVVUj4FAjR/xJ+cR+rWx6afDaeHk6/DNv57iuvi+GrXDE9pTKspm
         Z+RprMVGyXp927V3jlmzgLWjXLTP8g60L3Q/x6MDRE8jdQpNtJuHrXdxWof6/Eg0sBT8
         QKytkKdn8BHktinBGiuELIAFcudOQzsxu1CT1wdvc+jIEItdHGs0a8COyjNwQMmybDSm
         PLqQ==
X-Gm-Message-State: AGi0PuYGKirdwG53AEuSCGnUw9s6LtbTeDv+pl2FQjAKBe0OmI0LfvH7
        IplNy8bS/yuvwUEOlU1orD44zpgsm4EThw==
X-Google-Smtp-Source: APiQypKAcLjNI+wjN810Ef+x5XyZ6T1cGtNlEmqdvZg7BcqqhlUN/3uSKKzDUvvPwpOz8ZKjuQm9Kw==
X-Received: by 2002:a5d:950d:: with SMTP id d13mr3665917iom.136.1588689672924;
        Tue, 05 May 2020 07:41:12 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b1sm1146089ioe.46.2020.05.05.07.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 07:41:11 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
Date:   Tue, 5 May 2020 08:41:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 4:04 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> we currently have a bug report [1][2] regarding a data corruption with
> Samba's vfs_io_uring.c [3].
> 
> Is there're a know problem in newer kernels? It seems the 5.3 Kernel
> doesn't have the problem (at least Jeremy wasn't able to reproduce it
> on the Ubuntu 5.3 kernel).
> 
> Do you have any hints how to track that down?

I'll take a look at this! Any chance Jeremy can try 5.4 and 5.5 as well,
just to see where we're at, roughly? That might be very helpful.

-- 
Jens Axboe

