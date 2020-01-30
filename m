Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C7B14DEA5
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 17:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgA3QNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 11:13:37 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34906 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgA3QNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 11:13:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id y73so1743117pfg.2
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 08:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8uloMajxSLxz++zdVoJEdphcNnBeTWQqxTLIRZdrGI=;
        b=1aXpGoh4FUnVC0t5zVzxtASKBEKIQ+aNPK5pwfRlYfVstE2dW1Cya/J+ymxpghpG3B
         UxUZcWTpwKvhc6AZNQqT49hF6HalXWY59rCggAIWphroEGb0UsKHC2dYNmCuHpgZBArt
         mcN1u8YwInvt9jk5udVYafu/qyHbCR+OZPXiTkN8JUrpxq5KUXMILPzLThuJZvPGWWkA
         v9VIBfxsWlWioawUnT1jnWQsvpy7STNxP5l1mkjfzoZo2VG3lET6JDld/pJB7o+CBN+I
         9glB7sWSpXXEpc90ggQCSf4mvCuN3aaHUbRtcQXZU/QK76mv7mApj79kFEBlXb3eskqo
         iZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8uloMajxSLxz++zdVoJEdphcNnBeTWQqxTLIRZdrGI=;
        b=SfbvFGbhTyf3xbxTalqMxh0MTl3Z6IQ4F/lW39e92UAR1jo/kV99lBbLl12MNyOcVI
         RHSX3sOAqktqUCCR1ouCR+XDCSIc1LGO/1Hzbqb8t1bxgF/HM2tWyi7Gd+PDL/9hCZnJ
         nVFR16pxBJoNSllnmUjvWLIgcWCMMTNWNk4iyZtPsGpmTD0bXnqHof8o6JSS8xO1Jlqs
         PvPPhaaUKqOhTY/7SpHGpKUVh0hPHes/I+q1L3IxL/D4/uCpLP91t2yesIDMjBwDbUln
         9VZr/l64kkgvC7J4CZH7028N22FIBGKR7uc/ZOvyXJ/UvsqvCwvYd89H8FbzqtZIJUvg
         YC/A==
X-Gm-Message-State: APjAAAUP7ZOBMI5y6JBq9C7YKDqmPMtXKQKzxDKEL4MLDF3Y45PoJXvm
        d+fqJcqxG2EzhTmnKzlgQ1Zd/BIE1Sk=
X-Google-Smtp-Source: APXvYqwKQUNJhX8F+XtYhOHHmZUyqTVMw1xLjDTo85vY8jyQqJjQqUgEWddt5KNMiYw4S5q5ogzu1g==
X-Received: by 2002:a65:4c82:: with SMTP id m2mr5254871pgt.432.1580400815478;
        Thu, 30 Jan 2020 08:13:35 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1132::1035? ([2620:10d:c090:180::90b5])
        by smtp.gmail.com with ESMTPSA id bb5sm6793262pjb.8.2020.01.30.08.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 08:13:34 -0800 (PST)
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring
 functionality
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>
References: <20200130160013.21315-1-glauber@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
Date:   Thu, 30 Jan 2020 09:13:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130160013.21315-1-glauber@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 9:00 AM, Glauber Costa wrote:
> It is common for an application using an ever-evolving interface to want
> to inquire about the presence of certain functionality it plans to use.
> 
> Information about opcodes is stored in a io_uring_probe structure. There
> is usually some boilerplate involved in initializing one, and then using
> it to check if it is enabled.
> 
> This patch adds two new helper functions: one that returns a pointer to
> a io_uring_probe (or null if it probe is not available), and another one
> that given a probe checks if the opcode is supported.

This looks good, I committed it with minor changes.

On top of this, we should have a helper that doesn't need a ring. So
basically one that just sets up a ring, calls io_uring_get_probe(),
then tears down the ring.

-- 
Jens Axboe

