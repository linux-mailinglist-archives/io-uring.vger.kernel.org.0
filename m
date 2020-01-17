Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A4B1400BB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgAQAUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:20:03 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:38147 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAQAUC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:20:02 -0500
Received: by mail-pj1-f43.google.com with SMTP id l35so2457743pje.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 16:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8B5Nq8sPYPpc3UlE14hWp8Wwft0pfigihsrxwJmAYT0=;
        b=Z+o9e2zb62S9wkiiU9kPSQyzhVgOs4cs3u4t2uQuAnkjj6nbctat6iPFgGOtF0wOvY
         RPvondNfvVpnaYngqwP6oOTHjIy3WtTH2Al4ItWSFK67Ne59WH3y1dLv94isFwaOH9H+
         Q2+MvLELXtNOyiCMrYf78ACdyOEGlCP2Ng2nfIyXE2fmqVroLoDQSUuxzw5teQaXd4l8
         NrdY/M8KjDeRMuVAaGlSa2tCwuJ0OUJc8UTOWQMx3o4HxOLHrdJ2VQYRpKF4kFRAJEuS
         nrI2ADomlcN0hLfWbzNiWPtfbqswrWv1UQtK9psFh13OWJWa7TkHVJi/XDVVwlgi/yOz
         B2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8B5Nq8sPYPpc3UlE14hWp8Wwft0pfigihsrxwJmAYT0=;
        b=d8FNhwMH/HetuR5yGYMHaSyHmS8n93qmw/Ojvmq7JDw19+/ranSmHMxd5KxrDlsULL
         Y4TvGaCGiexa2HAz1MLhAOxqEIBLYEZTHCiWUnPg+peiMHRhsocm6fE2vS/AmeJA3rKB
         z5yKCbNdTlbMufFRmcbtST1qhN/3+u5bdH5ntIgGy+E6QXR3U3mA7eTgWjhZbR/8/DVP
         DjEwjzUJsh5dzeEToQRMzoB/weVMooMI5svEFZfApLgazGLI88YTsrijkXL6aItX2RDy
         s3z6HvrHatTfps/sE/bOVw8bIAjbvp8yGuSwwXgfBIu5s8MI/egR382Vr5qlwhafSIoe
         vuuQ==
X-Gm-Message-State: APjAAAVe6geE39QnHvHbEJ0yvbfCG/FgeNUwBDvMmb7qoxxxtf5IrkOv
        cS5SQqFzwMijgl48VMBdcTmoC/reasI=
X-Google-Smtp-Source: APXvYqzbgya3bUBC6aeHNFa6b1t1k3A3yaau1EbwfYSq6ykejaWxnouf1/Fec8N9jXXH4Q8oCpP2MA==
X-Received: by 2002:a17:902:247:: with SMTP id 65mr41054913plc.108.1579220401955;
        Thu, 16 Jan 2020 16:20:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g10sm25184747pgh.35.2020.01.16.16.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 16:20:01 -0800 (PST)
Subject: Re: Questions regarding IORING_OP_SENDMSG
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <74d50a99-9518-07c1-b8d7-83f49b907d12@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3673e2ec-7166-f2b2-48cd-1721057425e9@kernel.dk>
Date:   Thu, 16 Jan 2020 17:20:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <74d50a99-9518-07c1-b8d7-83f49b907d12@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 4:13 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> In the "io_uring: add support for IORING_OP_IOCTL" thread I wrote this:
> 
>> I could use also use a generic way for an async fd-based syscall.
>> I thought about using sendmsg() with special CMSG_ elements, but
>> currently it's not possible with IORING_OP_SENDMSG to do an async
>> io_kiocb based completion, using msg_iocb.
> 
> I just noticed that __sys_sendmsg_sock doesn't allow
> msg->msg_control || msg->msg_controllen.
> 
> Why is that the case?
> I could use that in several places for my smbdirect driver.
> 
> Optionally turning on msg_iocb usage would also be great,
> I'd use that in combination with MSG_OOB and CMSG_
> and this OOB message is not ordered like the typical
> sendmsg stream socket flow.
> 
> Do you think we can add support for this usecase?

It was done because of the CVE related to io_uring, but we really
don't need to since we have creds setup properly now. So it could
be allowed again.

-- 
Jens Axboe

