Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D691D168318
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 17:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgBUQRZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 11:17:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44383 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgBUQRY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 11:17:24 -0500
Received: by mail-pg1-f196.google.com with SMTP id a14so817710pgb.11
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 08:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aQGcVDwZYQWBOtAXil8SzgdiYPVSaSGZOeGTzRnc5aE=;
        b=igvfD2fJPKAX9ygqtJrrPalny2QTmYWCBA5aUcmDkKSmfijQRdypWy+AHX5MU5kLH5
         DKHxoGL1quqgjN8moD1oc+a7VeyYhurpgFd+P9B4kC2GHDHA/8shUcIpsC38TgwVals0
         xpDPT+Tvx/csZKZCHbBcq1s5ffaqFNU135vHx9669aK32fSDxBzBM96qb+YQKYlIgtk1
         KLC6F+x0A7d0NqLDbkrgxTdJTYnGSQtt3uH3UySe3cF7Q6CHbyzVlz3NuNJTTIY0P76A
         Z0q5MxJVZUKyXXIf1aXuISrJnJw9ux9nvLlrM/9G3qHIDTIbUGYQtRpLjM/+wn55mAQA
         B63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQGcVDwZYQWBOtAXil8SzgdiYPVSaSGZOeGTzRnc5aE=;
        b=pC8JbCR+AvlWkaTobFvI8SO01+3ysux0zcdsv6L5NxLVBKwB8wNbE3BYUaVnTpJzja
         7o9hPLSage6Qa4K1O95iEF6R7fJO1P2eS2WgSsiOOLuWPjRMt9naRo0uR7+uTPywxQb8
         gGyIAgD+rbExPjVsHQkN+VdC8TAn0PvUsDOuXVpSZik6fu1CWVnph5wq0zJWztbRVujr
         u/5zhPyyJsOMsrVWuZIs9NjZbf2QdalS44RWqshlVLt5RXD8mq7xh6RSYu5uiwpRPH23
         BfhcrdFduWftJIK8MR4IwpmdRGJuXArmYeqtvkhSxgeA2U2PRajEGgsvDBvwpyJsl7r/
         Jubw==
X-Gm-Message-State: APjAAAUpvuEMpP20c2UYWWFCz/SCl3Yhx2YjM8UzHn4PIzAUqK0dDpoL
        hW2W48ONDwtiREz/aRGnRLDu21cDLZg=
X-Google-Smtp-Source: APXvYqwUA11U5oDvifmSn/+wBEXU6Z5cSGYf+l+J+XGmsYkQFGr5FQgzrVuTtm9KseVvsIoREIbjdQ==
X-Received: by 2002:a65:424d:: with SMTP id d13mr40361290pgq.128.1582301842730;
        Fri, 21 Feb 2020 08:17:22 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id p16sm2944701pgi.50.2020.02.21.08.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:17:22 -0800 (PST)
Subject: Re: [PATCH liburing] test: add sq-poll-kthread test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200221154400.207213-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0f04c1d4-0688-41be-8889-9b18838053a1@kernel.dk>
Date:   Fri, 21 Feb 2020 08:17:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221154400.207213-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 8:44 AM, Stefano Garzarella wrote:
> sq-poll-kthread tests if the 'io_uring-sq' kthread is stopped
> when the userspace process ended with or without closing the
> io_uring fd.

Applied, thanks.

-- 
Jens Axboe

