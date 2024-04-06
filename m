Return-Path: <io-uring+bounces-1430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F87589ACE7
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 22:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7280CB22320
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 20:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002CA364BE;
	Sat,  6 Apr 2024 20:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="XVZqoPTK"
X-Original-To: io-uring@vger.kernel.org
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBF5184D;
	Sat,  6 Apr 2024 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712435578; cv=none; b=BHHr69eIAMSYpQz3Dnk4hfqM4PKqeqMptHVAtfvWc3ehuERAaTJ6sHoyJ5ANfIEZ79qPHmCvPXJtACapRhnvyLD3/Os+8fYYqcMJmMKC1lf+EnAVmnF9mTOhwU9NrrJgpqjI2xAiVr4qkZmRhNeL9LWg5Zxc21SJNKOMGmNr/Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712435578; c=relaxed/simple;
	bh=LAEg5Ivu9HF4b4fa+ZIoBLhuYmj8ETr3wPzmxKiEkbs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oZplvxCmN87/wlJOGuEj7DMlUQw+jKqaZcdL3mM6ZoS4ikXdFAJXuRtz2wdqGIRt3lZBd1YPQiKXby2YzPDlLZUL1l/1aJu4v27h9WdX3B1q1jwBpR8B1zaXHlaeTlJwgf3r49WSxrZYkSd9nrt6GQNgRPJb6L3uZmr8A3m5DhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=XVZqoPTK; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1712435568;
	bh=LAEg5Ivu9HF4b4fa+ZIoBLhuYmj8ETr3wPzmxKiEkbs=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=XVZqoPTKbgPtCX95A5JD+hPA+TmRg609YYOU4+m1BJc2vwrl2MtpRW2HfuH0HynOZ
	 oZurHqDTC5tTLiD0fg18tTDxWyHUKlIjyVsTUklIgxH2uoOjNW/GmM3Oox37HvTci/
	 d29wkDwGTS0fuRjMT4jaYj3tW48eXQ9GJpNVgqNemPbPk04KMQcwjQI+viW7EoTJc8
	 4EZJei+qUhYf8K1u36DZeOuvET9pQN8eqKQuuTZy9qPNFFb8FQ67eQSqXJcDSEVYkO
	 8pIEcNjTQKGq+rlRSugYTXPp0EfTZmpE0B09E+OFppZ+DcC9m+6ilaJhyVJDlxq+K1
	 u8Fxsw2oxifqQ==
Received: from [100.113.15.66] (ec2-34-240-57-77.eu-west-1.compute.amazonaws.com [34.240.57.77])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 7F15D37809D1;
	Sat,  6 Apr 2024 20:32:43 +0000 (UTC)
Message-ID: <4123ead2-9071-4ca2-8612-8999ed1140b3@collabora.com>
Date: Sun, 7 Apr 2024 01:33:16 +0500
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring: Support IOSQE_CQE_SKIP_SUCCESS in io_uring
 zerocopy test
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk,
 asml.silence@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, leitao@debian.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
 <d6d94eafa59055eaec8e554c3078f857c832a38e.1712268605.git.ozlinuxc@gmail.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <d6d94eafa59055eaec8e554c3078f857c832a38e.1712268605.git.ozlinuxc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 3:19 AM, Oliver Crumrine wrote:
> Add support for the IOSQE_CQE_SKIP_SUCCESS flag in the io_uring_zerocopy_tx
> test, using the "-a" option. Instead of incrementing when
> IORING_CQE_F_MORE is set, remember how many SQEs are sent and simply
> wait on notifs instead of regular completions. For non-zc stuff, there
> won't be notifs or completions, so don't wait on either of those, but
> check the completion queue for errors at the end to make sure none have
> popped up.
> 
> The changes to the shell script run the tests both with and without the
> "-a" option.
> 
> Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
Acked-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> ---
>  .../selftests/net/io_uring_zerocopy_tx.c      | 38 +++++++++++++++++--
>  .../selftests/net/io_uring_zerocopy_tx.sh     |  7 +++-
>  2 files changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
> index 76e604e4810e..11a43594935f 100644
> --- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
> +++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
> @@ -50,8 +50,10 @@ enum {
>  };
>  
>  static bool cfg_cork		= false;
> +static bool cfg_nocqe		= false;
>  static int  cfg_mode		= MODE_ZC_FIXED;
>  static int  cfg_nr_reqs		= 8;
> +static int  cfg_nr_completions	= 8;
>  static int  cfg_family		= PF_UNSPEC;
>  static int  cfg_payload_len;
>  static int  cfg_port		= 8000;
> @@ -134,11 +136,21 @@ static void do_tx(int domain, int type, int protocol)
>  			if (mode == MODE_NONZC) {
>  				io_uring_prep_send(sqe, fd, payload,
>  						   cfg_payload_len, msg_flags);
> +				if (cfg_nocqe) {
> +					sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
> +					cfg_nr_completions--;
> +				}
>  				sqe->user_data = NONZC_TAG;
>  			} else {
>  				io_uring_prep_sendzc(sqe, fd, payload,
>  						     cfg_payload_len,
>  						     msg_flags, zc_flags);
> +				if (cfg_nocqe) {
> +					sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
> +					packets++;
> +					compl_cqes++;
> +					bytes += cfg_payload_len;
> +				}
>  				if (mode == MODE_ZC_FIXED) {
>  					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
>  					sqe->buf_index = buf_idx;
> @@ -153,7 +165,7 @@ static void do_tx(int domain, int type, int protocol)
>  
>  		if (cfg_cork)
>  			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 0);
> -		for (i = 0; i < cfg_nr_reqs; i++) {
> +		for (i = 0; i < cfg_nr_completions; i++) {
>  			ret = io_uring_wait_cqe(&ring, &cqe);
>  			if (ret)
>  				error(1, ret, "wait cqe");
> @@ -168,7 +180,9 @@ static void do_tx(int domain, int type, int protocol)
>  				if (compl_cqes <= 0)
>  					error(1, -EINVAL, "notification mismatch");
>  				compl_cqes--;
> -				i--;
> +				if (!cfg_nocqe)
> +					i--;
>  				io_uring_cqe_seen(&ring);
>  				continue;
>  			}
> @@ -200,6 +214,17 @@ static void do_tx(int domain, int type, int protocol)
>  		compl_cqes--;
>  	}
>  
> +	/* The above code does not account for a send error when
> +	 * IOSQE_CQE_SKIP_SUCCESS is set. This is operating under the
> +	 * assumption that an error CQE will get put on the ring before
> +	 * the above code completes:
> +	 */
> +	while (!io_uring_peek_cqe(&ring, &cqe)) {
> +		if (cqe->res == -EAGAIN)
> +			continue;
> +		error(1, -EINVAL, "send failed");
> +	}
> +
>  	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
>  			packets, bytes >> 20,
>  			packets / (cfg_runtime_ms / 1000),
> @@ -221,7 +246,7 @@ static void do_test(int domain, int type, int protocol)
>  static void usage(const char *filepath)
>  {
>  	error(1, 0, "Usage: %s (-4|-6) (udp|tcp) -D<dst_ip> [-s<payload size>] "
> -		    "[-t<time s>] [-n<batch>] [-p<port>] [-m<mode>]", filepath);
> +		    "[-t<time s>] [-n<batch>] [-p<port>] [-m<mode>] [-a]", filepath);
>  }
>  
>  static void parse_opts(int argc, char **argv)
> @@ -239,7 +264,7 @@ static void parse_opts(int argc, char **argv)
>  		usage(argv[0]);
>  	cfg_payload_len = max_payload_len;
>  
> -	while ((c = getopt(argc, argv, "46D:p:s:t:n:c:m:")) != -1) {
> +	while ((c = getopt(argc, argv, "46aD:p:s:t:n:c:m:")) != -1) {
>  		switch (c) {
>  		case '4':
>  			if (cfg_family != PF_UNSPEC)
> @@ -274,6 +299,9 @@ static void parse_opts(int argc, char **argv)
>  		case 'm':
>  			cfg_mode = strtol(optarg, NULL, 0);
>  			break;
> +		case 'a':
> +			cfg_nocqe = true;
> +			break;
>  		}
>  	}
>  
> @@ -302,6 +330,8 @@ static void parse_opts(int argc, char **argv)
>  		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
>  	if (optind != argc - 1)
>  		usage(argv[0]);
> +
> +	cfg_nr_completions = cfg_nr_reqs;
>  }
>  
>  int main(int argc, char **argv)
> diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> index 123439545013..aeb4645b7891 100755
> --- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> +++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> @@ -25,11 +25,14 @@ readonly path_sysctl_mem="net.core.optmem_max"
>  # No arguments: automated test
>  if [[ "$#" -eq "0" ]]; then
>  	IPs=( "4" "6" )
> +	SKIPCQEs=("" "-a")
>  
>  	for IP in "${IPs[@]}"; do
>  		for mode in $(seq 1 3); do
> -			$0 "$IP" udp -m "$mode" -t 1 -n 32
> -			$0 "$IP" tcp -m "$mode" -t 1 -n 1
> +			for cqe in "${SKIPCQEs[@]}"; do
> +				$0 "$IP" udp -m "$mode" -t 1 -n 32 "$cqe"
> +				$0 "$IP" tcp -m "$mode" -t 1 -n 1  "$cqe"
> +			done
>  		done
>  	done
>  

-- 
BR,
Muhammad Usama Anjum

