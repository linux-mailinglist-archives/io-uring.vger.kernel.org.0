Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BD4171FB8
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 15:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbgB0OiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 09:38:07 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40005 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732202AbgB0N4s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 08:56:48 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so3247871iop.7
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 05:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R+SoRazeZGWCcamx/h04PzBGW1A7arrsbxdwnu8tWtk=;
        b=MMUwvKtcpPAvkKN+kPsK1Sje4a1KILb+I1pnGx83EPQlWylcvbM+WBbiE/9jD7BFJ2
         IaJBGGUBSLvQMAkshSAE+6gHpQPbIYP0EFZMdnDwbzuskKR44dFUKcbaheYtVUpL0oRD
         cjlNWNtoSxVH+9tokSQinWATuGxWZR4UBLBoCDfurc1b5hhhr17ARrWtNxsuTuXLvTKf
         4K+jmx/u0TXbGw1HxVMfvmrCX4lnC6E8ykns2vqrF+m69hlUc3sBC+T8wzG9nL779AP/
         oYxt+f7xcYUtzCtZUqtXWo3pM7s8u0WvPULzc8x+AC4akuurpVi2z+i3HrhfEvXq6ooc
         yiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R+SoRazeZGWCcamx/h04PzBGW1A7arrsbxdwnu8tWtk=;
        b=ew6kxUTMsWgiRu9VaueHXlFYsNL+xSTmbsZHrE4D+4HU7TqN4tfxFITNHjPoxisBkw
         /5hiAeEVjb/FyJRgnM10/VGCqOLn+CyUd1kK6C2OZxfFPsPTAl/Fy8qOUJqtHYrp+VcX
         vjOiQ5E5NVwOvZ79qaM7Y8Qi1ZgxB/YSGK5EbCqJpejzR3rFhb25liV0i9M7DWmKUfa3
         jCAtkre2b0yMZZ13OVZCMqBoO6cdV+XjYyIBeq8x0iXi3bJFEb/sdkhbzmNPnZFwHNKv
         1OpAPwa3+C3wneKAfKTP3uMoChhVX1lUhfiteX0zxKlM8Xgt9HoetAfQCUdGRsk8Y4X7
         kHcw==
X-Gm-Message-State: APjAAAXPyEbQy31jJVpsXaYYwESAqMb2dJ3w2XyVwChBp3D+fZx8+F8F
        2Hi1XQS/zcL9zDMp6C7kCL9OlFKAzFCeVQ==
X-Google-Smtp-Source: APXvYqzQad+7ikffGpwz7dpY+EX0A0h9+anSEnIFkAU5zm0Qx5dPFs1jZSbhl+kJ7oj6AOo9rDMqZg==
X-Received: by 2002:a05:6638:501:: with SMTP id i1mr5754177jar.25.1582811807097;
        Thu, 27 Feb 2020 05:56:47 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm1386071ioh.87.2020.02.27.05.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 05:56:46 -0800 (PST)
Subject: Re: [PATCH] io_uring: use correct CONFIG_PROC_FS define
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     io-uring@vger.kernel.org
References: <20200227130856.15148-1-tklauser@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27593a49-d50a-6296-a4b7-f35ba09014fb@kernel.dk>
Date:   Thu, 27 Feb 2020 06:56:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227130856.15148-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/27/20 6:08 AM, Tobias Klauser wrote:
> Commit 6f283fe2b1ed ("io_uring: define and set show_fdinfo only if
> procfs is enabled") used CONFIG_PROCFS by mistake. Correct it.

Oops - I folded this into the original.

-- 
Jens Axboe

