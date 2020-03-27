Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15773195955
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgC0Oyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 10:54:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33388 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0Oyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 10:54:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id g18so3553712plq.0
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2020 07:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zJ0PPi7rS3oz6b2eaRCjQoF84OOkeDJtXCN+2vC3sOQ=;
        b=GazMjaErJPHoV6kotKr2M2oQxFkVnL1MV5fuJrZX6owzDTsT9uxrmqCxQzWR+p5vDX
         P81K2vuI+kJTRQ5y6sWRz03JK8OCv/atex+PPecCpl4wVrfMB1EP9GY6r8iiMmI8sh5V
         aXZ+UCvmTE9hAOjEpyCvcGYtLSsB8WGfzjntF4Zcp3GKULUuLuWhBulq3eQgtujl0CLL
         2vlX5sJWnbBmTGyMoQo0Krw5bRDMQ2MP1u9IzYHt/g9RInctf1HIYrUjNYDXqfdqDplF
         UF7pdzDfdT+WUrGmkH+EjRswpY3FpTsYuR3uSGCWCjHli7bVxkKwGVpl2C8YJLVgKUxS
         qQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJ0PPi7rS3oz6b2eaRCjQoF84OOkeDJtXCN+2vC3sOQ=;
        b=KA5WhmRjHpgPJ3+QbL/fCeTKHo7ggPun5aGcNuZUelKBlv3JKWuFWNJWiZEmlOwcMX
         6a8taUZ4VucZcFekF7afYgysUvAG2eesAPShzTDLACOdlf0Y7kazGQSo0su7lUpVNf0V
         QMg0IYd2b5PvbIknckbKzxBF18mJDWtL2lUCAUYClZSstUJggIBz7AtJuFbbYRb12N81
         XYqp9P98kl2q+qyf04BTesN/Wrr4A4bStm5GGL9ewzfaO2WfLJgLxsA81E4zSdbu0kuE
         JxH6pt/0DJgN9jqsOhssEgIcx3Vszg2Vou9p7iDLTueh/3X9HbfOtJOFdt+anrv4QgLH
         rPEg==
X-Gm-Message-State: ANhLgQ2Tn7fvplBdID3Iq7clFT3VFEdUP5sMlLqQ4qvP52qzt7iVUVU4
        FSTUIPNVdzxbShGc4oxfzA6bP9HgV5HexA==
X-Google-Smtp-Source: ADFU+vu2WE2/4eoE1TDz9ADfJARhF3ikHnHjUKacWjf3Gsu7/IDEKZvw3EufeE3zPtq4qvWWjLX9eg==
X-Received: by 2002:a17:902:a416:: with SMTP id p22mr13937347plq.57.1585320882246;
        Fri, 27 Mar 2020 07:54:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z7sm4321720pfz.24.2020.03.27.07.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 07:54:41 -0700 (PDT)
Subject: Re: [PATCH] io_uring: cleanup io_alloc_async_ctx()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200327073652.2301-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2f31d0f-b886-a4a8-5599-82f8173dacd4@kernel.dk>
Date:   Fri, 27 Mar 2020 08:54:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200327073652.2301-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/20 1:36 AM, Xiaoguang Wang wrote:
> Cleanup io_alloc_async_ctx() a bit, add a new __io_alloc_async_ctx(),
> so io_setup_async_rw() won't need to check whether async_ctx is true
> or false again.

Applied, thanks.

-- 
Jens Axboe

