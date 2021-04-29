Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563AC36EC5A
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 16:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhD2O1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 10:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240363AbhD2O1a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 10:27:30 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF766C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:26:40 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r5so14074008ilb.2
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzFdny3nubWlbRZ3GjiwVJiy9s0egitn06I0uWUZTNg=;
        b=LbNlTRfGHXmL8f+XkLyphOy/aqSviOoPh34CjlOc15bmmhnpfgTkkSAS7295yEt8Rg
         kgxKvS4jb1eR4IXQuJRv4efXBNTN6cupJMDw+5SDNGmAEg+lOcZTeBf1r6SdNqXvx4B7
         BV+scTImbPMzt5ojekx+FXTMJI+jSKwJ2FEwNVNP50mriZ95TtA0qqY7gx88AyHmq4j7
         ZQvu1RZbRgCjwKMTD26ul0nPSIgdAAKBPye4tVD009Pg6fD9hJb6YhNtpQK8VInZlDTF
         o79SwpJwtm582Iq4E1obqsabAnnDP5MBoGkgPZpKMHK774AsPmfLDnM9dimDBcm/Qa0w
         sANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzFdny3nubWlbRZ3GjiwVJiy9s0egitn06I0uWUZTNg=;
        b=LqydMEazhD1g0SWFdB2nfkQdwzFR+oC24yS8KbW9TdQ9TSSdI3zAFVZ7c/vGQ9Xi7k
         BN7LANDxnD3StxiwYZhdnGI5XaX3DwZiDGPvT0DvapTwO7dQ3kUa/QQ4XSWP7MR4n2FG
         Zwbte9drGaDvpYQMtJuesDaSRQWjlrVkroCxG/ZpI7wjXkOdHr0pc64urrDUV4Bx872b
         GNwmnbgCc5+4ESrM0DGhuGnKV8m04bBOHy21c0FcpX9N+/5EaW40TSTuB1exBeknVl2m
         oHHp9pjG+zKDTK9L+glm2QQcwmlUEJPjkGzcuXOJViWt2THgCtP1Jg4h324kAv2GDRj8
         R/Uw==
X-Gm-Message-State: AOAM531MmMDbUN3xWsJrz8Obzx3wjDDq01GgItg/bXIn19CcEVgaGcJY
        wUJN5DnieL1BfJCkFeprDbtMkA==
X-Google-Smtp-Source: ABdhPJycXVLlXeDJ6PutYq0PD0IetjC9zjbZlZri3WX1DFejMRz8e9E3G6sFpEvcvv1T42dlYHGJtg==
X-Received: by 2002:a92:d092:: with SMTP id h18mr22130ilh.62.1619706399467;
        Thu, 29 Apr 2021 07:26:39 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm1427988ilq.64.2021.04.29.07.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 07:26:38 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix unchecked error in switch_start()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com
References: <c4c06e2f3f0c8e43bd8d0a266c79055bcc6b6e60.1619693112.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9ea67ec2-a5e5-7f3b-5427-52f7cfdffc49@kernel.dk>
Date:   Thu, 29 Apr 2021 08:26:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c4c06e2f3f0c8e43bd8d0a266c79055bcc6b6e60.1619693112.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 4:46 AM, Pavel Begunkov wrote:
> io_rsrc_node_switch_start() can fail, don't forget to check returned
> error code.

Applied, thanks.

-- 
Jens Axboe

