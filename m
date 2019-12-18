Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92C123B46
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 01:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLRADA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 19:03:00 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:50815 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfLRADA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 19:03:00 -0500
Received: by mail-pj1-f53.google.com with SMTP id r67so6404pjb.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 16:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5nJ+jJHzCJTI6fI9kgUKUKhNPF63RFbng1tOaU2bTXk=;
        b=Vz+/nqLNL2ztWQbnOrYZ2bYroFYW3yLJIJutl4Nuxd/HHZ4jVMfPaT0zYEIauzhtwX
         1fd/lfzxFiV70TZfM9yalhCktpeA4qIhSytgLItkSpfByAnbyjPGqa9jadPbMYolvmHw
         juKokiJNcOtO2AAUd7VfOtPaUkUISDuBuntarlFeh3kqaKjsz3n4CsE1Xh8uURAuNSXn
         Wg+dFp6qrK+MRYfH6PQi7HdhjMAvkZBc+8egZP7PskZPE6LGzl3UnvRKksQNhE4nJgRI
         f4VHhrMAdF0wYWOnjXJ9K7TDM/Jq1nBLsf9GVAOESGVTBv6n8xx6Z98N+fW1rvpwnD0n
         eAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nJ+jJHzCJTI6fI9kgUKUKhNPF63RFbng1tOaU2bTXk=;
        b=IHHQSz8YR6QUEwVlvLgoFX8QFR8pCqgwIlWF8JmC2pvdvMBHOUgdH1MG+bsPBhgwv0
         dVHbveV67HUUtJq/DKkKpgCKjG/F6EaRBiPRztP2qiXPVPalsPlKfmB+P327VzIZySjQ
         NLSO5JaS+lGYHmy0eattnW5HM2oqPc2rUBtcNVOBtS9sHX6ydNjz4VI4KaArrVzaW+Kn
         7McxGhfDyRzDxA/i9+VdpvolYHZoYlUEBna5yOyAzSCR1AGU0mPHQN3tUnvqLyPjMom7
         aB/mbWOsoQFrii6pQzAKjosBx/3balS54XRYvbqzyUN3XN6YX4cU2x+VJ3fx8WmLHhXQ
         8o1Q==
X-Gm-Message-State: APjAAAWR0d4SjFJ1fldrnLUsDXkAvocB4S4BB25xft8xVGdzv0zIOieD
        u6od+LYDhOGE8QQ9tcBqkmEn1A==
X-Google-Smtp-Source: APXvYqyer7SSfxCJCfuc/q08fRBQh2cvjZTzzf1GB+/hS63zzq/Et3sw4HyTUgZxfSK8W+iBylCOYw==
X-Received: by 2002:a17:90a:ff12:: with SMTP id ce18mr140958pjb.117.1576627379651;
        Tue, 17 Dec 2019 16:02:59 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::13f4? ([2620:10d:c090:180::6446])
        by smtp.gmail.com with ESMTPSA id t30sm127292pgl.75.2019.12.17.16.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 16:02:59 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ae04c15-e410-5ecc-660a-389fbb03d8ea@kernel.dk>
Date:   Tue, 17 Dec 2019 17:02:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 3:28 PM, Pavel Begunkov wrote:
> percpu_ref_tryget() has its own overhead. Instead getting a reference
> for each request, grab a bunch once per io_submit_sqes().
> 
> basic benchmark with submit and wait 128 non-linked nops showed ~5%
> performance gain. (7044 KIOPS vs 7423)

Confirmed about 5% here as well, doing polled IO to a fast device.
That's a huge gain!

-- 
Jens Axboe

